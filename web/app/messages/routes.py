from flask import request, jsonify, g, current_app, send_from_directory
from werkzeug.utils import secure_filename
from ..models import User, Platforms, Follow, Messages
import time
from ..utils import allowed_file
from ..extensions import basic_auth, token_auth, db, os, hashlib
import datetime
from collections import defaultdict


from . import messages_bp


@messages_bp.route('/message/send', methods=['POST'])
@token_auth.login_required
def send_message():
    request_body = request.get_json()
    receiver = request_body['username']
    message = request_body['message']
    receiver_user = User.query.filter_by(username=receiver)
    if receiver_user is None:
        return jsonify({'success': False, 'msg': 'user does not exist'}), 404

    message_to_add = Messages(
        recipient=receiver, issuer=g.user.username, body=message, timestamp=time.time_ns())
    db.session.add(message_to_add)
    db.session.commit()

    return jsonify({'success': True, 'msg': 'message sent successfuly'}), 202


@messages_bp.route('/message/retrieve_chats', methods=['GET'])
@token_auth.login_required
def retrieve_chats():
    sent_messages = Messages.query.filter_by(issuer=g.user.username).all()
    received_messages = Messages.query.filter_by(
        recipient=g.user.username).all()
    chats = defaultdict(
        lambda: {'timestamp': 0, 'message': Messages()})

    for message in sent_messages:
        other_user = message.recipient
        if message.timestamp > chats[other_user]['timestamp']:
            chats[other_user] = {
                'timestamp': message.timestamp, 'message': message}

    for message in received_messages:

        other_user = message.issuer
        if message.timestamp > chats[other_user]['timestamp']:
            chats[other_user] = {
                'timestamp': message.timestamp, 'message': message}

    sorted_chats = sorted(
        chats.items(), key=lambda x: x[1]['timestamp'], reverse=True)
    


    response = [{'user': User.query.filter_by(username=x).first().serialize(), 'last_message': y['message'].serialize()}
                for x,y in sorted_chats]

    return jsonify(response), 200


'''this is the endpoint used to get the chat with a user'''


@messages_bp.route('/message/retrieve_messages', methods=['POST'])
@token_auth.login_required
def retrieve_messages():
    request_body = request.get_json()
    user = request_body['username']
    sent_messages = Messages.query.filter_by(
        issuer=g.user.username, recipient=user).all()
    received_messages = Messages.query.filter_by(issuer=user,
                                                 recipient=g.user.username).all()
    chats = sent_messages + received_messages

    sorted_chats = sorted(
        chats, key=lambda x: x.timestamp, reverse=False)

    return jsonify([msg.serialize() for msg in sorted_chats]), 200

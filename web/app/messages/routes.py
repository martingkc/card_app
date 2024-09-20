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
    sender = g.user
    receiver_user = User.query.filter_by(username=receiver)
    if receiver_user is None:
        return jsonify({'success': False, 'msg': 'user does not exist'}), 404

    message_to_add = Messages(
        recipient=receiver, issuer=g.user.username, body=message, )
    db.session.add(message_to_add)
    db.session.commit()

    return jsonify({'success': True, 'msg': 'message sent successfuly'}), 404


@messages_bp.route('/message/retrieve_chats', methods=['GET'])
@token_auth.login_required
def retrieve_chats():
    sent_messages = Messages.query.filter_by(issuer=g.user.username).all()
    received_messages = Messages.query.filter_by(
        recipient=g.user.username).all()
    chats = defaultdict(
        lambda: {'last_message': None, 'timestamp': datetime.datetime.min})

    for message in sent_messages:
        print(message.body)
        other_user = message.recipient
        if message.timestamp > chats[other_user]['timestamp']:
            chats[other_user] = {
                'last_message': message.body, 'timestamp': message.timestamp}

    for message in received_messages:
        print(message.body)

        other_user = message.issuer
        if message.timestamp > chats[other_user]['timestamp']:
            chats[other_user] = {
                'last_message': message.body, 'timestamp': message.timestamp}

    sorted_chats = sorted(
        chats.items(), key=lambda x: x[1]['timestamp'], reverse=True)

    response = [{'user': user, 'last_message': details['last_message']}
                for user, details in sorted_chats]

    return jsonify(response), 200

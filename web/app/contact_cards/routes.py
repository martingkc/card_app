from flask import request, jsonify, g, current_app
from ..models import ContactItems, Platforms
from ..extensions import basic_auth, token_auth, db
from ..utils import create_vcf
from . import contacts_bp


@contacts_bp.route('/update_card', methods=['POST'])
@token_auth.login_required
def add_contact_cards():
    request_body = request.get_json()
    if not request_body:
        return jsonify({"error": "Invalid request body"}), 400

    ContactItems.query.filter_by(username=g.user.username).delete()
    db.session.commit()

    for item in request_body['items']:
        platform = Platforms[item['platform']]
        link = item['link']
        if (platform.name == 'Contact'):
            create_vcf(g.user)
            link = current_app.config['DOMAIN'] + "/api/vcf/" + g.user.username+'.vcf'
        contact_item = ContactItems(
            username=g.user.username, type=platform, link=link)
        db.session.add(contact_item)
    db.session.commit()
    return {"message": "Contacts updated successfully"}, 201


@contacts_bp.route('/contact_info/<string:username>', methods=['GET'])
def get_contact_cards(username):
    contacts = ContactItems.query.filter_by(username=username).all()
    return jsonify([contact.serialize() for contact in contacts]), 200

from flask import request, jsonify, g, url_for, current_app, send_from_directory,render_template
from werkzeug.utils import secure_filename
from ..models import ContactItems, User, Platforms
from ..utils import allowed_file
from ..extensions import basic_auth, token_auth, db, os, hashlib


from . import site_bp


@site_bp.route('/users/<string:username>')
def get_user(username):
    user = User.query.filter_by(username=username).first()
    contacts = ContactItems.query.filter_by(username=username).all()
    domain = current_app.config['DOMAIN']

    if user.profile_picture is not None : 
        profile_picture_link =  domain +"/api/files/"+ user.profile_picture
    else:
        profile_picture_link = ""
    if not user:
       return 404


    return render_template('card.html', 
                           user=user, 
                           profile_picture_url= profile_picture_link,
                           contacts=contacts)
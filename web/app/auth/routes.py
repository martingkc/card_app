from flask import g, jsonify
from ..extensions import basic_auth, token_auth, db
from ..models import User, Platforms
from . import auth_bp

@basic_auth.verify_password
def verify_password(username, password):
    user = User.query.filter_by(username=username).first()
    if not user or not user.verify_password(password):
        return False
    g.user = user
    return True

@auth_bp.route('/token', methods=['GET'])
@basic_auth.login_required
def get_auth_token():
    token = g.user.generate_auth_token(600)
    return jsonify({'token': token, 'duration': 600})

@token_auth.verify_token
def verify_token(token):
    user = User.verify_auth_token(token)
    if not user:
        return False
    g.user = user
    return True

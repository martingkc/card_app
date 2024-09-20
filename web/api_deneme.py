#!/usr/bin/env python
import os
import time
import hashlib
from enum import Enum
from werkzeug.utils import secure_filename
from flask import (
    Flask, abort, request, jsonify, g, url_for, send_from_directory, render_template
)
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_httpauth import HTTPBasicAuth, HTTPTokenAuth
import jwt
from werkzeug.security import generate_password_hash, check_password_hash


app = Flask(__name__,  template_folder='templates')
app.config['SECRET_KEY'] = 'the quick brown fox jumps over the lazy dog'
UPLOAD_FOLDER = os.path.abspath(os.path.join(os.path.dirname(__file__), 'Downloads'))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
ALLOWED_EXTENSIONS = {'xls', 'csv', 'png', 'jpeg', 'jpg', 'jpg'}
app.config['MAX_CONTENT_LENGTH'] = 500 * 1000 * 1000  # 500 MB
app.config['CORS_HEADER'] = 'application/json'

db = SQLAlchemy(app)
basic_auth = HTTPBasicAuth()
token_auth = HTTPTokenAuth(scheme='Bearer')


class Platforms(Enum):
    Facebook = 'Facebook'
    Instagram = 'Instagram'
    Website = 'Website'
    LinkedIn = 'LinkedIn'
    WhatsApp = 'WhatsApp'
    Contact = 'Contact'


class ContactItems(db.Model):
    __tablename__ = 'userContacts'
    id = db.Column(db.Integer, index=True)
    username = db.Column(db.String(32), primary_key=True)
    type = db.Column(db.Enum(Platforms), primary_key=True)
    link = db.Column(db.String(128), index=True)

    def serialize(self):
        return {
            'platform': self.type.value,
            'link': self.link
        }

class Contacts(db.Model): 
    __tablename__ = 'userFollowers'
    followerName = db.Column(db.String(32), primary_key=True)
    username = db.Column(db.String(32), primary_key=True)


class User(db.Model):
    __tablename__ = 'users'
    username = db.Column(db.String(32), primary_key=True)
    name = db.Column(db.String(32), index=True)
    surname = db.Column(db.String(32), index=True)
    email = db.Column(db.String(32), index=True)
    phoneNumber = db.Column(db.String(32), index=True)
    companyName = db.Column(db.String(32), index=True, nullable= True)
    password_hash = db.Column(db.String(128))
    profile_picture = db.Column(db.String(128), nullable = True)
    role = db.Column(db.String(128))

    def hash_password(self, password):
        self.password_hash = generate_password_hash(password)

    def verify_password(self, password):
        return check_password_hash(self.password_hash, password)

    def generate_auth_token(self, expires_in=600):
        return jwt.encode(
            {'username': self.username, 'exp': time.time() + expires_in},
            app.config['SECRET_KEY'], algorithm='HS256'
        )

    @staticmethod
    def verify_auth_token(token):
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
        except jwt.ExpiredSignatureError:
            return None  # Token expired
        except jwt.InvalidTokenError:
            return None  # Invalid token
        return User.query.filter_by(username=data['username']).first()


@token_auth.verify_token
def verify_token(token):
    user = User.verify_auth_token(token)
    if not user:
        return False  # Token verification failed
    g.user = user  # Set the authenticated user in `g`
    return True  # Token is valid


@basic_auth.verify_password
def verify_password(username, password):
    user = User.verify_auth_token(username)
    if not user:
        user = User.query.filter_by(username=username).first()
        if not user or not user.verify_password(password):
            return False

    g.user = user
    return True


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/api/users', methods=['POST'])
def new_user():
    username = request.json.get('username')
    password = request.json.get('password')
    company = request.json.get('company')
    name = request.json.get('name')
    surname = request.json.get('surname')
    phnumber = request.json.get('number')
    mail = request.json.get('mail')
    role = request.json.get('role')

    if not username or not password:
        abort(400)  # Missing arguments
    if User.query.filter_by(username=username).first() is not None:
        abort(400)  # Existing user
    user = User(
        username=username, name=name, surname=surname, email=mail,
        phoneNumber=phnumber, companyName=company, role=role
    )
    user.hash_password(password)
    db.session.add(user)
    db.session.commit()
    return (
        jsonify({'username': user.username}), 201,
        {'Location': url_for('get_user', username=username, _external=True)}
    )


@app.route('/api/users/<string:username>')
def get_user(username):
    user = User.query.filter_by(username=username).first()
    if not user:
        abort(400)
    return jsonify({'username': user.username, 
                    'name': user.name, 
                    'surname': user.surname,
                    'company': user.companyName, 
                    'role': user.role, 
                    'profile_picture': user.profile_picture})


@token_auth.get_user_roles
def get_user_roles(user):
    return user.role


@app.route('/api/token', methods=['GET'])
@basic_auth.login_required
def get_auth_token():
    token = g.user.generate_auth_token(600)
    return jsonify({'token': token, 'duration': 600})


@app.route('/api/resource', methods=['GET'])
@token_auth.login_required(role='admin')
def get_resource():
    return jsonify({'data': f'Hello, {g.user.username}!'})


@app.route('/api/contact_info/<string:username>', methods=['GET'])
def get_contacts(username):
    contacts = ContactItems.query.filter_by(username=username).all()
    return jsonify([contact.serialize() for contact in contacts]), 200


@app.route('/api/update_card', methods=['POST'])
@token_auth.login_required
def add_contacts():
    if not hasattr(g, 'user'):
        return jsonify({"error": "User not authenticated"}), 401

    request_body = request.get_json()
    if not request_body:
        return jsonify({"error": "Invalid request body"}), 400

    ContactItems.query.filter_by(username=g.user.username).delete()
    db.session.commit()

    for item in request_body['items']:
        platform = Platforms[item['platform']]
        link = item['link']
        contact_item = ContactItems(username=g.user.username, type=platform, link=link)
        db.session.add(contact_item)

    db.session.commit()
    return {"message": "Contacts updated successfully"}, 201


@app.route('/api/trends', methods=['GET'])
@token_auth.login_required
def get_trends():
    return jsonify({'data': 'deneme'})




@app.route('/api/change_profile_picture', methods=['POST'])
@token_auth.login_required
def change_profile_picture():
    file = request.files.get('files')
    if not file:
        return jsonify({'message': 'No file provided'}), 400

    filename = secure_filename(file.filename)
    if not allowed_file(filename):
        return jsonify({'message': 'File type not allowed'}), 400

    file.seek(0)
    sha256_hash = hashlib.file_digest(file, 'sha256').hexdigest()
    file.seek(0)

    path = os.path.join(app.config['UPLOAD_FOLDER'], g.user.username)
    os.makedirs(path, exist_ok=True)
    
    if g.user.profile_picture is str:
        old_path = os.path.join(app.config['UPLOAD_FOLDER'], g.user.profile_picture)
        if os.path.exists(old_path):
            os.remove(old_path)

    file.save(os.path.join(path, filename))
    
    g.user.profile_picture = os.path.join(g.user.username, filename)
    db.session.commit()

    return jsonify({
        "name": filename,
        "status": "success",
        "path": g.user.profile_picture,
        "sha256": sha256_hash
    })

@app.route("/api/files/<path:filename>")
def get_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename, as_attachment=True)


@app.route('/users/<string:username>')
def display_user(username):
    #user = User.query.filter_by(username=username).first()
    #if not user:
    #    abort(400)
    return   render_template('hello.html')
    #return jsonify({'username': user.username, 
    #                'name': user.name, 
    #                'surname': user.surname,
    #                'company': user.companyName, 
    #                'role': user.role, 
    #                'profile_picture': user.profile_picture})


if __name__ == '__main__':
    if not os.path.exists('db.sqlite'):
        with app.app_context():
            db.create_all()
   
    app.run(debug=True, port=4999)


from flask import request, jsonify, g, current_app, send_from_directory
from werkzeug.utils import secure_filename
from ..models import User, Platforms, Follow
from ..utils import allowed_file
from ..extensions import basic_auth, token_auth, db, os, hashlib


from . import user_bp


@user_bp.route('/change_profile_picture', methods=['POST'])
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

    path = os.path.join(current_app.config['UPLOAD_FOLDER'], g.user.username)
    os.makedirs(path, exist_ok=True)

    if g.user.profile_picture is str:
        old_path = os.path.join(
            current_app.config['UPLOAD_FOLDER'], g.user.profile_picture)
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


@user_bp.route("/files/<path:filename>")
def get_file(filename):
    return send_from_directory(current_app.config['UPLOAD_FOLDER'], filename, as_attachment=True)


@user_bp.route("/vcf/<path:filename>")
def get_vcf(filename):
    return send_from_directory(current_app.config['CONTACT_FOLDER'], filename, as_attachment=True)


@user_bp.route('/users/<string:username>', methods=['GET'])
def get_user(username):
    user = User.query.filter_by(username=username).first()
    if not user:
        abort(400)
    return user.serialize()


@user_bp.route('/users/follow', methods=['POST'])
@token_auth.login_required
def follow_user():
    request_body = request.get_json()
    username = request_body['username']
    print(username)
    user_to_add = User.query.filter_by(username=username).first()
    if not user_to_add:
        return (
            jsonify({'success': False, 'username': user_to_add.username}), 400
        )
    follow_registry = Follow.query.filter_by(
        follower=g.user.username, following=user_to_add.username).first()
    if follow_registry is not None:
        return (
            jsonify({'success': False, 'username': user_to_add.username}), 409
        )
    follow = Follow(follower=g.user.username, following=user_to_add.username)
    db.session.add(follow)
    db.session.commit()
    return (
        jsonify({'success': True, 'username': user_to_add.username}), 201
    )


@user_bp.route('/users/unfollow', methods=['POST'])
@token_auth.login_required
def unfollow_user():
    request_body = request.get_json()
    username = request_body['username']
    user_to_remove = User.query.filter_by(username=username).first()

    if user_to_remove is None:
        return jsonify({'success': False, 'username': username, 'msg': 'user does not exist'}), 404
    else:
        user_to_remove = Follow.query.filter_by(
            follower=g.user.username, following=username).first()
        if user_to_remove is None:
            return jsonify({'success': False, 'username': username, 'msg': 'follow not found'}), 404
        else:
            Follow.query.filter_by(
                follower=g.user.username, following=username).delete()

            db.session.commit()
            return jsonify({'success': True, 'username': username, 'msg': 'removed'}), 200


@user_bp.route('/users/following')
@token_auth.login_required
def get_followers():
    follow_registry = Follow.query.filter_by(follower=g.user.username).all()
    return jsonify([following.serialize() for following in follow_registry]), 200


@user_bp.route('/users/add', methods=['POST'])
def new_user():
    username = request.json.get('username')
    password = request.json.get('password')
    company = request.json.get('company')
    name = request.json.get('name')
    surname = request.json.get('surname')
    phnumber = request.json.get('phone_number')
    mail = request.json.get('email')
    role = request.json.get('role')

    if not username or not password:
        abort(400)
    if User.query.filter_by(username=username).first() is not None:
        abort(400)
    user = User(
        username=username, name=name, surname=surname, fullname=name + ' ' + surname, email=mail,
        phoneNumber=phnumber, companyName=company, role=role
    )
    user.hash_password(password)
    db.session.add(user)
    db.session.commit()
    return (
        jsonify({'username': user.username}), 201,
        {'Location': url_for('get_user', username=username, _external=True)}
    )


@user_bp.route('/users/search/<string:query>')
def searchUser(query):
    match_by_name = User.query.filter(User.name.like(f"%{query}%")).all()
    match_by_username = User.query.filter(
        User.username.like(f"%{query}%")).all()
    result = {'fullname_matches': [user.serialize() for user in match_by_name], 'username_matches': [
        user.serialize() for user in match_by_username]}
    return (jsonify(result), 200)

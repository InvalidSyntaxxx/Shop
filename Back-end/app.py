from datetime import date

from flask import Flask, request, make_response, render_template, jsonify, session
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import and_, or_
from flask_cors import CORS
from flask_cors import cross_origin
import os,sys,random,string

from werkzeug.security import check_password_hash
# 工程文件路径
rootpath = "C:/Users/86199/Desktop/数据库学习笔记/数据库课设/Front-end"


app = Flask(__name__)


# 设置连接数据库的URL(你的数据库账号:你的数据库密码@数据库外网地址:端口/数据库)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:123@baidu.com:3306/chat'

# 设置json格式
app.config['JSON_AS_ASCII'] = False

# 设置每次请求结束后会自动提交数据库中的改动
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
# 会话密钥
app.secret_key = b'123456'

db = SQLAlchemy(app)

# 定义模型
class Goods(db.Model):
    __tablename__ = 'Goods'
    goods_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), nullable=False)
    img = db.Column(db.String(64))
    type = db.Column(db.String(32))
    # 简介
    description = db.Column(db.String(200))
    # 库存
    count = db.Column(db.Integer)
    price = db.Column(db.Float)
    # 销量
    goods_sale= db.Column(db.Integer)

class User(db.Model):
    __tablename__ = 'User'
    # 账号
    user_id = db.Column(db.Integer, primary_key=True)
    # 密码
    password = db.Column(db.String(64), nullable=False)
    # 昵称
    nikename = db.Column(db.String(64))
    # 姓名
    name = db.Column(db.String(64))
    sex= db.Column(db.String(16))
    address = db.Column(db.String(64))
    phone = db.Column(db.String(16))
    mail = db.Column(db.String(32))

class Car(db.Model):
    __tablename__ = 'Car'
    car_id = db.Column(db.Integer, primary_key=True)
    # 数量
    count = db.Column(db.Integer)
    # User外键
    user_id = db.Column(db.Integer, db.ForeignKey('User.user_id'))
    User = db.relationship('User', backref='carts')
    # goods外键
    goods_id = db.Column(db.Integer, db.ForeignKey('Goods.goods_id'))
    Goods = db.relationship('Goods', backref='carts')

class Order(db.Model):
    __tablename__ = 'Order'
    order_id = db.Column(db.Integer, primary_key=True)
    # 收货人姓名
    name = db.Column(db.String(64))
    # 收货地址
    address = db.Column(db.String(64))
    phone = db.Column(db.String(16))
    # 价格
    sum = db.Column(db.Float)
    # 数量
    count = db.Column(db.Integer)
    # 下单时间
    time = db.Column(db.Date)
    # User外键
    user_id = db.Column(db.Integer, db.ForeignKey('User.user_id'))
    User = db.relationship('User', backref='orders')
    # goods外键
    goods_id = db.Column(db.Integer, db.ForeignKey('Goods.goods_id'))
    Goods = db.relationship('Goods', backref='orders')

class category(db.Model):
    __tablename__ = 'category'
    types_id = db.Column(db.Integer, primary_key=True)
    classification = db.Column(db.String(32))

@app.route('/')
@cross_origin(supports_credentials=True)
def index():
    return ''

# 商品处理 ###############################################

# 商品转json
def goods_to_products(items):
    products = []
    for item in items:
        product = {
            "id": item.goods_id,
            "name": item.name,
            "description": item.description,
            "price": item.price,
            "img": item.img,
            "type": item.type,
            "number": item.count,
            "see": "999+",
            "love": "999+",
            "hot": item.goods_sale,
            'inventory':item.count
        }
        products.append(product)
    return jsonify(products)
# 图片储存
@app.route('/upload',methods=['POST','GET'])
@cross_origin(supports_credentials=True)
def pictrue_save():
    if(request.method == 'POST'):
        # 获取图片文件
        img = request.files['img']
        path = rootpath+"/public/images/products/" + img.filename
        img.save(path)
        return 'ok'
# 请求处理
@app.route('/products', methods=['GET', 'POST', 'PUT', 'DELETE'])
@cross_origin(supports_credentials=True)
def products():
    if (request.method == 'POST'):
        if(request.args.get('DeleteID') == None):
            # 添加商品
            latest = Goods.query.order_by(Goods.goods_id.desc()).first().goods_id
            id = latest + 1
            name = request.form['name']
            image = request.form['filename']
            type = request.form['type']
            description = request.form['description']
            count = request.form['inventory']
            price = request.form['price']
            goods_sale = 0
            product = Goods(goods_id=id, name=name, img=image, type=type, description=description, count=count,
                            price=price,
                            goods_sale=goods_sale)
            db.session.add(product)
            db.session.commit()
            return ''
        else:
            # 删除
            id = request.args.get('DeleteID')
            product = Goods.query.filter_by(goods_id=id).first()
            db.session.delete(product)
            db.session.commit()
            return ''
        return ''
    elif (request.method == 'GET'):
        # 展示商品
        items = Goods.query.all()
        products = goods_to_products(items)
        return products
    elif (request.method == 'PUT'):
        id = request.form['id']
        product = Goods.query.filter_by(goods_id=id).first()
        product.name = request.form['name']
        product.img = request.form['filename']
        product.type = request.form['type']
        product.description = request.form['description']
        product.count = request.form['inventory']
        product.price = request.form['price']
        db.session.commit()
        return ''
###############################################################################


# 类别#######################################################################
# 分类转json
def types_to_fenlei(items):
    fenlei = []
    for item in items:
        category = {
            'id' : item.types_id,
            'classification' : item.classification
        }
        fenlei.append(category)
    return jsonify(fenlei)
# 请求处理
@app.route('/fenlei', methods=['GET', 'POST'])
@cross_origin(supports_credentials=True)
def fenlei():
    if(request.method == 'GET'):
        items = category.query.all()
        categories = types_to_fenlei(items)
        return categories
##############################################################################


# 购物车处理 ###################################################################
# 购物车转json
def cart_to_preorder(items):
    preorders = []
    for item in items:
        product = Goods.query.filter_by(goods_id=item.goods_id).first()
        preorder = {
            'id': item.car_id,
            'name': product.name,
            'img': product.img,
            'type': product.type,
            'price': product.price,
            'count': item.count,
            'sum': item.count * product.price,
            'description': product.description
        }
        preorders.append(preorder)
    return jsonify(preorders)
# 请求处理
@app.route('/cart', methods=['GET', 'POST','PUT'])
@cross_origin(supports_credentials=True)
def shop_cart():
    if(request.method=='GET'):
        # 展示购物车
        user_id = 1
        user_now = User.query.filter_by(user_id=user_id).first()
        carts_now = user_now.carts
        preorders = cart_to_preorder(carts_now)
        return preorders
    elif(request.method=='POST'):
        if(request.args.get('DeleteID') == None):
            # 将商品加入购物车
            latest = Car.query.order_by(Car.car_id.desc()).first().car_id
            car_id = latest + 1
            count = 1
            goods_id = int(request.form['id'])
            user_id = 1
            preorder = Car(car_id=car_id, count=count, goods_id=goods_id, user_id=user_id)
            db.session.add(preorder)
            db.session.commit()
            return ''
        else:
            # 撤销购物车中的订单
            id = request.args.get('DeleteID')
            preorder = Car.query.filter_by(car_id=id).first()
            db.session.delete(preorder)
            db.session.commit()
            return ''
    elif(request.method=='PUT'):
        # 修改数量
        id = request.form['id']
        preorder = Car.query.filter_by(car_id=id).first()
        preorder.count = request.form['count']
        db.session.commit()
        return ''
    return ''
#############################################################################


# 订单处理####################################################################
# order转json
def order_to_json(items):
    orders = []
    for item in items:
        product = Goods.query.filter_by(goods_id=item.goods_id).first()
        time = item.time.strftime("%Y-%m-%d %H:%M:%S")
        order_json = {
            'id': item.order_id,
            'goods_name': product.name,
            'count': item.count,
            'sum': item.sum,
            'name': item.name,
            'phone': item.phone,
            'address': item.address,
            'time': time,
            'img': product.img,
            'description': product.description
        }
        orders.append(order_json)
    return jsonify(orders)
# 请求处理
@app.route('/order', methods=['POST', 'GET','PUT'])
@cross_origin(supports_credentials=True)
def op_order():
    if (request.method == 'GET'):
        # 展示订单
        user_id = 1
        user_now = User.query.filter_by(user_id=user_id).first()
        orders = user_now.orders
        orders_json = order_to_json(orders)
        return orders_json
    elif (request.method == 'POST'):
        if(request.args.get('DeleteID')==None):
            # 从购物车中下单
            latest = Order.query.order_by(Order.order_id.desc()).first().order_id
            order_id = latest+1
            user_id = 1
            # 用购物车中意向订单编号去找到所需商品编号
            cart_id = request.form['id']
            goods_id = Car.query.filter_by(car_id=cart_id).first().goods_id
            user_now = User.query.filter_by(user_id=user_id).first()
            name = user_now.name
            address = user_now.address
            phone = user_now.phone
            count = request.form['count']
            price = request.form['price']
            sum = int(count)*int(price)
            time = date.today()
            order_now = Order(order_id=order_id,user_id=user_id,goods_id=goods_id,name=name,address=address,phone=phone,sum=sum,count=count,time=time)
            db.session.add(order_now)
            db.session.commit()
            # 删除购物车记录
            preorder = Car.query.filter_by(car_id=cart_id).first()
            db.session.delete(preorder)
            db.session.commit()
            return ''
        else:
            # 撤销订单
            id = request.args.get('DeleteID')
            order_now = db.session.query(Order).filter_by(order_id=id).first()
            db.session.delete(order_now)
            db.session.commit()
            return ''
    elif (request.method == 'PUT'):
        # 修改订单信息,只能改收货人信息
        id = request.form['id']
        order_now = Order.query.filter_by(order_id=id).first()
        order_now.name = request.form['name']
        order_now.address = request.form['address']
        order_now.phone = request.form['phone']
        db.session.commit()
        return ''
    return ''
############################################################################


# 用户管理#################################################
# user转json
def user_json(item):
    user_now = {
        'id': item.user_id,
        'nikename': item.nikename,
        'password': item.password,
        'name': item.name,
        'sex': item.sex,
        'address': item.address,
        'phone': item.phone,
        'mail': item.mail
    }
    return jsonify(user_now)
# 请求处理
@app.route('/user', methods=['GET','POST','PUT'])
@cross_origin(supports_credentials=True)
def op_user():
    if(request.method == 'GET'):
        # 用户信息查看
        user_id = 1
        user_now = User.query.filter_by(user_id=user_id).first()
        user_now_json = user_json(user_now)
        return user_now_json
    if(request.method == 'POST'):
        # 用户注册
        latest = User.query.order_by(User.user_id.desc()).first().user_id
        user_id = latest + 1
        nikename = request.form['nikename']
        password = request.form['password']
        mail = request.form['email']
        user_now = User(user_id=user_id, nikename=nikename, password=password, name='无', sex='保密', address='无',
                        phone='无', mail=mail)
        db.session.add(user_now)
        db.session.commit()
        return 'success'
    if(request.method == 'PUT'):
        # 修改信息
        user_id = 1
        user_now=Order.query.filter_by(user_id=user_id).first()
        user_now.password = request.form['password']
        user_now.name = request.form['name']
        user_now.sex = request.form['sex']
        user_now.address = request.form['address']
        user_now.phone = request.form['phone']
        user_now.mail = request.form['mail']
        user_now.nikename = request.form['nikename']
        db.session.commit()
        return ''
    return ''
#########################################################


# 用户登录##################################################
@app.route('/login', methods=['POST', 'GET'])
@cross_origin(supports_credentials=True)

def login():
    with app.app_context():
        if(request.method == 'POST'):
            nikename = request.form['nikename']
            password = request.form['password']
            users = User.query.filter_by(nikename=nikename).all()
            for item in users:
                if password == item.password:
                    return "success"
            else:
                print("Error!!")
                return 'error'
        return ''
@app.route('/logout')
@cross_origin(supports_credentials=True)
def logout():
    if(request.method == 'POST'):
        session.pop('uid', None)
        return 'success'
    return ''
##########################################################

if __name__ == '__main__':
    # 通过CORS，所有的来源都允许跨域访问
    CORS(app, supports_credentials=True)
    app.run(debug=True, host='localhost', port=53000)


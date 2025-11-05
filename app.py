from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return '<h1>Bonjour depuis Docker et Python! 🐳</h1><p>Mon application fonctionne parfaitement!</p>'

@app.route('/health')
def health():
    return {'status': 'healthy', 'message': 'API en marche'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

@app.route('/api/version')
def version():
    return {'version': '1.0.0', 'author': 'AY00Z'}

@app.route('/docker')
def docker_info():
    return '<h2>🚀 Déployé avec Docker!</h2><p>CI/CD avec Jenkins</p>'

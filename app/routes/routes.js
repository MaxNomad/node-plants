module.exports = function(app, db) {




    app.get('/test', (req, res) => {
        res.send({ 'Text1': 'test message' }); 
    });
    app.get('/', (req, res) => {
        res.send({ 'data': 'yaroslav molodec' }); 
    });
};
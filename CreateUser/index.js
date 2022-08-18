module.exports = async function (context) {
    context.log('JavaScript trigger function processed a request.');
    return {
        body: "Hello World!"
    };
};
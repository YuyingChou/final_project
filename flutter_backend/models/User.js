const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    username: {
        type: String,
        require: true,
        min: 3,
        max: 20,
        unique: true,
    },
    email:{
        type: String,
        require: true,
        max: 50,
        unique: true,
    },
    password:{
        type: String,
        require:true,
        min: 6,
    },
    studentId:{
        type: String,
        require: true,
        max: 10,
        unique: true,
    },
    Department:{
        type: String,
        require: true,
    },
    Year:{
        type: String,
        require: true,
    },
    gender:{
        type: String,
        require: true,
    },
    phoneNumber:{
        type: String,
        require: true,
        max: 11
    }
},{ timestamps: true }
); 

module.exports = mongoose.model("User", UserSchema);
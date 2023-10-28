const mongoose = require('mongoose');

const InfoSchema = new mongoose.Schema({
    roomType: {
        type: String,
        required: true,
    },
    title: {
        type: String,
        required: true,
    },
    location: {
        type: String,
        required: true,
    },
    price: {
        type: String,
        required: true,
    },
    landlordName: {
        type: String,
        required: true,
    },
    landlordContact: {
        type: String,
        required: true,
    },
    expectedEndDate: {
        type: String,
        required: true,
    },
    rating: {
        type: Number,
        required: true,
    },
    image: {
        type: String,
    },
    facilities: {
        type: [String],
    },
}, { timestamps: true });

module.exports = mongoose.model("Info", InfoSchema);
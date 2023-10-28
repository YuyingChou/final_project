const express = require('express');
const router = express.Router();
const Info = require('../../models/Infos');
const bcrypt = require('bcrypt');

// publishHouse
router.post('/publishHouse', async (req, res) => {
    try {
        const houseData = req.body;
        console.log("Received house data:", houseData);

        const newHouse = new Info({
            roomType: houseData.roomType,
            title: houseData.title,
            location: houseData.location,
            price: houseData.price,
            landlordName: houseData.landlordName,
            landlordContact: houseData.landlordContact,
            expectedEndDate: houseData.expectedEndDate,
            rating: houseData.rating,
            image: houseData.image,
            facilities: houseData.facilities,
        });

        const savedHouse = await newHouse.save();

        res.status(200).json({ success: true, message: "发布成功", data: savedHouse });
    } catch (err) {
        res.status(400).json({ success: false, error: err.message });
    }
});

// 后端路由
router.get('/getRentItems', async (req, res) => {
    try {
        const rentItems = await Info.find(); // 使用Mongoose查询数据库获取所有租赁信息
        res.status(200).json({ success: true, data: rentItems });
    } catch (err) {
        res.status(400).json({ success: false, error: err.message });
    }
});



module.exports = router;

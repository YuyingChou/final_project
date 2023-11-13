const router = require('express').Router();
const User = require('../../models/User');
const bcrypt = require('bcrypt');

//register
router.post('/register',async (req, res)=>{
    try {
        //generate a password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(req.body.password,salt);
        
        //create new user
        const newUser = new User({
            username: req.body.username,
            email: req.body.email,
            password: hashedPassword,
            studentId: req.body.studentId,
            Department: req.body.Department,
            Year: req.body.Year,
            gender: req.body.gender,
            phoneNumber: req.body.phoneNumber
        });

        //save user and sned response
        const user = await newUser.save();
        res.status(200).json({ success: true, message: "註冊成功" });
    } catch (err) {
        res.status(400).json({ success: false, error: err.message });
    }
});

//login
router.post('/login', async (req, res) => {
    try {
        //find user
        const user = await User.findOne({ username: req.body.username });
        if (!user) {
            return res.status(400).json("使用者名稱或密碼錯誤!");
        }
        //validate password
        const validPassword = await bcrypt.compare(
            req.body.password,
            user.password
        );
        if (!validPassword) {
            return res.status(400).json("使用者名稱或密碼錯誤!");
        }
        //send response
        return res.status(200).json({ _id: user._id, username: user.username });
    } catch (err) {
        return res.status(400).json(err);
    }
});

//get user information
router.get('/user/:id', async (req, res) => {
    try {
      const userId = req.params.id;
      const user = await User.findOne({ _id: userId }); 
      if (user) {
        return res.status(200).json(user);
      } else {
        return res.status(400).json({ message: '使用者不存在' });
      }
    } catch (err) {
      return res.status(500).json({ message: '伺服器發生錯誤' });
    }
});

//edit user profile
router.put('/:id', async (req, res) => {
    try {
      const updatedUser = await User.findByIdAndUpdate(
        req.params.id, 
        req.body, 
        { new: true }
      );
      if (!updatedUser) {
        res.status(400).json({ message: '找不到此用户' });
        return;
      } 
      res.status(200).json(updatedUser);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: '服务器错误' });
    }
});
  
module.exports = router;
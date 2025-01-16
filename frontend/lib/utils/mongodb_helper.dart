import 'package:mongo_dart/mongo_dart.dart';
import 'otp_generator.dart';

class MongoDBHelper {
  static final String mongoUri = "mongodb://dishinshah2006:YRM1X4C4VZkVSAF3@cluster0-shard-00-00.jpxpk.mongodb.net:27017,cluster0-shard-00-01.jpxpk.mongodb.net:27017,cluster0-shard-00-02.jpxpk.mongodb.net:27017/Login_signup?ssl=true&replicaSet=atlas-abc123-shard-0&authSource=admin&retryWrites=true&w=majority";
  static final String dbName = "Login_signup";
  static final String collectionName = "sign_up";

  static Future<DbCollection?> getCollection() async {
    try {
      final db = Db(mongoUri);
      await db.open();
      return db.collection(collectionName);
    } catch (e) {
      print("Error connecting to MongoDB: $e");
      return null;
    }
  }

  static Future<bool> checkIfPhoneExists(String phone) async {
    try {
      final collection = await getCollection();
      if (collection == null) return false;
      final user = await collection.findOne({"phone": phone});
      return user != null;
    } catch (e) {
      print("Error checking phone existence: $e");
      return false;
    }
  }

  static Future<bool> registerUser(String name, String phone) async {
    try {
      final collection = await getCollection();
      if (collection == null) return false;
      final otp = OTPGenerator.generateOTP();
      await collection.insertOne({"name": name, "phone": phone, "otp": otp});
      print("Generated OTP: $otp"); // Remove in production
      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  static Future<bool> verifyOTP(String phone, String otp) async {
    try {
      final collection = await getCollection();
      if (collection == null) return false;
      final user = await collection.findOne({"phone": phone, "otp": otp});
      return user != null;
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }

  static Future<String> getUserName(String phone) async {
    try {
      final collection = await getCollection();
      if (collection == null) return "User";
      final user = await collection.findOne({"phone": phone});
      return user?['name'] ?? "User";
    } catch (e) {
      print("Error getting user name: $e");
      return "User";
    }
  }
}

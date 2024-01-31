import '../models/mail_model.dart';
import '../models/user_model.dart';

class EmailUtility {
  static MailModel getEmailBody(
      UserModel userModel, int propertyId, String message) {
    return MailModel(
        from: "propsotec@gmail.com",
        to: "akx.sonu@gmail.com,propertycphelp@gmail.com,propsoleads1@gmail.com",
        subject: "Property Enquiry from ${userModel.fullName}",
        html: getHtmlBody(userModel, propertyId, message));
  }

  static getHtmlBody(UserModel userModel, int propertyId, String message) {
    return '''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Property Enquiry</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
      }

      .container {
        max-width: 600px;
        margin: 20px auto;
        background-color: #fff;
        border-radius: 1px;
        overflow: hidden;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }

      table {
        width: 100%;
        border-collapse: collapse;
      }

      th,
      td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
      }

      th {
        background-color: rgb(70, 150, 236);
        color: white;
      }

      tr:hover {
        background-color: #f5f5f5;
      }

      h2 {
        background-color: rgb(70, 150, 236);
        color: white;
        padding: 15px;
        margin: 0;
      }

      .content {
        padding: 20px;
      }

      .footer {
        background-color: #333;
        color: white;
        text-align: left;
        font-size: x-small;
        padding: 10px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h2>Property Enquiry</h2>
      <div class="content">
        <table>
          <tr>
            <th>Customer ID</th>
            <td>${userModel.id}</td>
          </tr>
          <tr>
            <th>Name</th>
            <td>${userModel.fullName}</td>
          </tr>
          <tr>
            <th>Phone</th>
            <td>${userModel.mobileNo}</td>
          </tr>
          <tr>
            <th>Property</th>
            <td>
              <a
                href="http://13.48.104.206:3000/$propertyId"
                target="_blank"
                rel="noopener noreferrer"
                >Click to view</a
              >
            </td>
          </tr>
        </table>
        <br />
        <h4>Message</h4>

        $message
      </div>
      <div class="footer">
        Please do not reply to this email. Your reply will not reach to the
        customer, instead use the above customer phone number to communicate.
      </div>
    </div>
  </body>
</html>

''';
  }
}

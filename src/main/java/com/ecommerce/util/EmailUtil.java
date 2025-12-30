package com.ecommerce.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * 邮件发送工具类 (简化版)
 */
public class EmailUtil {
    // ========================================================================
    // 邮件服务器配置
    // ========================================================================
    private static String SMTP_HOST;
    private static String SMTP_PORT;
    private static String USERNAME;
    private static String PASSWORD;
    private static String FROM_EMAIL;

    static {
        try {
            java.util.Properties props = new java.util.Properties();
            try (java.io.InputStream in = EmailUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
                if (in != null) {
                    props.load(in);
                    SMTP_HOST = props.getProperty("email.smtp.host");
                    SMTP_PORT = props.getProperty("email.smtp.port");
                    USERNAME = props.getProperty("email.username");
                    PASSWORD = props.getProperty("email.password");
                    FROM_EMAIL = USERNAME;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 发送邮件
     */
    public static boolean sendEmail(String toEmail, String subject, String content) {
        // 检查是否配置了邮箱
        if (USERNAME == null || USERNAME.isEmpty() || USERNAME.contains("YOUR_EMAIL")) {
            System.err.println("【警告】邮件发送失败：请先在 src/main/resources/config.properties 中配置真实的邮箱账号和授权码！");
            System.out.println("模拟发送邮件内容: " + subject + " -> " + toEmail);
            return false;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            // QQ邮箱可能需要以下SSL配置
            // props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(USERNAME, PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("邮件发送成功: " + toEmail);
            return true;
        } catch (Exception e) {
            System.err.println("邮件发送异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 发送发货通知邮件 (支付成功后)
     */
    public static boolean sendOrderConfirmation(String toEmail, String customerName, 
                                                 int orderId, double totalAmount) {
        String subject = "订单发货通知 - 订单号: " + orderId;
        String content = String.format(
            "<html><body>" +
            "<h2>订单已发货</h2>" +
            "<p>尊敬的 %s，</p>" +
            "<p>感谢您的付款！您的订单已经处理完毕并已发货。</p>" +
            "<div style='background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;'>" +
            "<p><strong>订单号：</strong>%d</p>" +
            "<p><strong>支付金额：</strong>¥%.2f</p>" +
            "<p><strong>状态：</strong>已发货</p>" +
            "</div>" +
            "<p>您可以在“我的订单”中查看详细信息。</p>" +
            "<p>感谢您的支持！</p>" +
            "<p>电商平台团队</p>" +
            "</body></html>",
            customerName, orderId, totalAmount
        );
        return sendEmail(toEmail, subject, content);
    }
}

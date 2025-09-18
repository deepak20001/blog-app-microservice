import nodemailer from "nodemailer";

export const sendEmail = async (
    name: string,
    email: string,
    template: string
    ): Promise<void> => { 
    try {
        if (!process.env.SMTP_USER || !process.env.SMTP_PASSWORD) {
            throw new Error("SMTP_USER or SMTP_PASSWORD is undefined");
        }
        
        const transporter = nodemailer.createTransport({
            host: "smtp.gmail.com",
            port: 587,
            secure: false, 
            auth: {
                user: process.env.SMTP_USER as string,
                pass: process.env.SMTP_PASSWORD as string,
            },
        });
        
        await transporter.sendMail({
        from: `"Blog App" <${process.env.SMTP_USER}>`,
        to: email,
        subject: `Hello ${name || "user"}`,
        html: template,
        });
        console.log(`Email sent successfully to ${email}`);
    } catch (error) {
        console.error("Error sending email:", error);
        throw error; 
    }
};

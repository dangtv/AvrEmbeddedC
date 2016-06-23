namespace Mach
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.btSend = new System.Windows.Forms.Button();
            this.t1 = new System.Windows.Forms.TextBox();
            this.com = new System.Windows.Forms.ComboBox();
            this.btConnect = new System.Windows.Forms.Button();
            this.serialPort1 = new System.IO.Ports.SerialPort(this.components);
            this.TextReceived = new System.Windows.Forms.RichTextBox();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.SuspendLayout();
            // 
            // btSend
            // 
            this.btSend.Location = new System.Drawing.Point(199, 46);
            this.btSend.Name = "btSend";
            this.btSend.Size = new System.Drawing.Size(75, 23);
            this.btSend.TabIndex = 0;
            this.btSend.Text = "Send";
            this.btSend.UseVisualStyleBackColor = true;
            this.btSend.Click += new System.EventHandler(this.button1_Click);
            // 
            // t1
            // 
            this.t1.Location = new System.Drawing.Point(51, 46);
            this.t1.Name = "t1";
            this.t1.Size = new System.Drawing.Size(100, 20);
            this.t1.TabIndex = 1;
            this.t1.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // com
            // 
            this.com.FormattingEnabled = true;
            this.com.Location = new System.Drawing.Point(51, 13);
            this.com.Name = "com";
            this.com.Size = new System.Drawing.Size(100, 21);
            this.com.TabIndex = 3;
            // 
            // btConnect
            // 
            this.btConnect.Location = new System.Drawing.Point(199, 13);
            this.btConnect.Name = "btConnect";
            this.btConnect.Size = new System.Drawing.Size(75, 23);
            this.btConnect.TabIndex = 4;
            this.btConnect.Text = "Connect";
            this.btConnect.UseVisualStyleBackColor = true;
            this.btConnect.Click += new System.EventHandler(this.button1_Click_1);
            // 
            // serialPort1
            // 
            this.serialPort1.PortName = "COM4";
            this.serialPort1.DataReceived += new System.IO.Ports.SerialDataReceivedEventHandler(this.serialPort1_DataReceived);
            // 
            // TextReceived
            // 
            this.TextReceived.Location = new System.Drawing.Point(51, 117);
            this.TextReceived.Name = "TextReceived";
            this.TextReceived.Size = new System.Drawing.Size(221, 50);
            this.TextReceived.TabIndex = 5;
            stringReceived = "";
            this.TextReceived.Text = stringReceived;
            this.TextReceived.TextChanged += new System.EventHandler(this.richTextBox1_TextChanged);
            // 
            // timer1
            // 
            this.timer1.Interval = 1;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(395, 262);
            this.Controls.Add(this.TextReceived);
            this.Controls.Add(this.btConnect);
            this.Controls.Add(this.com);
            this.Controls.Add(this.t1);
            this.Controls.Add(this.btSend);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Name = "Form1";
            this.Text = "Nhom Hai-Chien";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btSend;
        private System.Windows.Forms.TextBox t1;
        private System.Windows.Forms.ComboBox com;
        private System.Windows.Forms.Button btConnect;
        private System.IO.Ports.SerialPort serialPort1;
        private System.Windows.Forms.RichTextBox TextReceived;
        private System.Windows.Forms.Timer timer1;
        private string stringReceived;
        private double temp;
        private string receivedData = "";
        private bool isReceivedData = true;
    }
}


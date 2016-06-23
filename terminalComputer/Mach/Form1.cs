using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;
using System.IO;

namespace Mach
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            for(int i = 0; i < t1.Text.Length; i++)
            {
                serialPort1.Write(t1.Text[i]+"");
                System.Threading.Thread.Sleep(100);
                
            }
            
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            String[] ComName = SerialPort.GetPortNames();
            foreach (string s in ComName)
            {
                com.Items.Add(s);
            }
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            serialPort1.PortName = com.Text;
            try
            {
                if (!serialPort1.IsOpen)
                {
                    serialPort1.Open();
                    MessageBox.Show("Ket noi thanh cong");
                    btConnect.Text = "Disconnect";
                }
                else
                {
                    serialPort1.Close();
                    btConnect.Text = "Connect";
                }
            }
            catch
            {

            }
        }

        private void serialPort1_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            string s = serialPort1.ReadExisting();

            if (isReceivedData)
            {
                if (s[0] == '&')
                {
                    receivedData += s;
                    isReceivedData = false;
                }
                else { stringReceived += s + "" + "(" + s.Length + ")"; }
            }
            else
            {
                receivedData += s;
                if(s[s.Length-1] == '#')
                {
                    // nhan xong goi tin, boc goi tin de lay du lieu
                    isReceivedData = true;
                    if (receivedData.Length == 7)
                    {
                        if ((receivedData[2] - 1) == 0)
                        {
                            temp = (receivedData[4] - 1) + (receivedData[5] - 1) / 10.0;
                            stringReceived += "__ nhiet do: " + temp.ToString() + "__";
                        }
                        if ((receivedData[2] - 1) == 1)
                        {
                            int Hour = receivedData[3] - 1;
                            int Minute = receivedData[4] - 1;
                            int Second = receivedData[5] - 1;
                            stringReceived += "__ thoi gian: " + Hour.ToString() + ":" + Minute.ToString() + ":" + Second.ToString() + "__";
                        }
                    }
                }

            }
            
            
            Display(stringReceived);
        }

        private delegate void DlDisplay(string s);
        private void Display(string s)
        {
            if (TextReceived.InvokeRequired)
            {
                DlDisplay sd = new DlDisplay(Display);
                TextReceived.Invoke(sd, new object[] { s });
            }
            else
            {
                TextReceived.Text = s;
            }
        }

        private void richTextBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            
        }
    }
}

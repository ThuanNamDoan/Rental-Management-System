using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace GUI_V_2
{
    public partial class ChuNha : Form
    {
        public ChuNha()
        {
            InitializeComponent();
        }


        [DllImport("user32.DLL", EntryPoint = "ReleaseCapture")]
        private extern static void ReleaseCapture();
        [DllImport("user32.DLL", EntryPoint = "SendMessage")]
        private extern static void SendMessage(System.IntPtr hwnd, int wmsg, int wparam, int lparam);

        private void BarraTitulo_MouseDown(object sender, MouseEventArgs e)
        {
            ReleaseCapture();
            SendMessage(this.Handle, 0x112, 0xf012, 0);
        }

        private void AbrirFormEnPanel(object Formhijo)
        {
            if (this.panelContenedor.Controls.Count > 0)
                this.panelContenedor.Controls.RemoveAt(0);
            Form fh = Formhijo as Form;
            fh.TopLevel = false;
            fh.Dock = DockStyle.Fill;
            this.panelContenedor.Controls.Add(fh);
            this.panelContenedor.Tag = fh;
            fh.Show();
        }

        private void btnprod_Click(object sender, EventArgs e)
        {
            AbrirFormEnPanel(new DangBaiChoBan());
        }

        private void btnlogoInicio_Click(object sender, EventArgs e)
        {
            AbrirFormEnPanel(new DangBaiChoBan());
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            btnlogoInicio_Click(null, e);
        }

        private void Button4_Click(object sender, EventArgs e)
        {
            AbrirFormEnPanel(new DangBaiChoThue());
        }

        private void Button2_Click(object sender, EventArgs e)
        {
            AbrirFormEnPanel(new LichSuBaiDang());
        }

        private void Button3_Click(object sender, EventArgs e)
        {
            AbrirFormEnPanel(new ThongTinChuNha());
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            AbrirFormEnPanel(new QuanLyNhaChuNha());
        }

        private void Button6_Click(object sender, EventArgs e)
        {
            AbrirFormEnPanel(new LichXemNhaChuNha());
        }
    }
}

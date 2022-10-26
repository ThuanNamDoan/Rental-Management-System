using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace GUI_V_2
{
    public partial class ThongTinKhachHang : Form
    {
        public ThongTinKhachHang()
        {
            InitializeComponent();
            TenTextBox.ReadOnly = true;
            SDTTextBox.ReadOnly = true;
            DiaChiTextBox.ReadOnly = true;
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            if (SuaThongTinKH.Text == "Sửa thông tin")
            { 
                SuaThongTinKH.Text = "Lưu thông tin";
                TenTextBox.ReadOnly = false;
                SDTTextBox.ReadOnly = false;
                DiaChiTextBox.ReadOnly = false;
            }
            else
            { 
                SuaThongTinKH.Text = "Sửa thông tin";
                TenTextBox.ReadOnly = true;
                SDTTextBox.ReadOnly = true;
                DiaChiTextBox.ReadOnly = true;
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace GUI_V_2
{
    public partial class ThongTinChuNha : Form
    {
        static string cnstr = @"Data Source =.; Initial Catalog = QuanLyThueBanNha; Integrated Security = True";
        public ThongTinChuNha()
        {
            InitializeComponent();
            TenTextBox.ReadOnly = true;
            SDTTextBox.ReadOnly = true;
            DiaChiTextBox.ReadOnly = true;
        }

        private void SuaThongTinKH_Click(object sender, EventArgs e)
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
                using (var cn = new SqlConnection { ConnectionString = cnstr })
                {
                    using (var cmd = new SqlCommand
                    {
                        Connection = cn,
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        cmd.CommandText = "dbo.[CapNhatChuNha]";

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@maChuNha",
                            SqlDbType = SqlDbType.Char
                        }).Value = "own_1";

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@ten",
                            SqlDbType = SqlDbType.Char
                        }).Value = TenTextBox.Text;

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@sdt",
                            SqlDbType = SqlDbType.Char
                        }).Value = SDTTextBox.Text;

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@diaChi",
                            SqlDbType = SqlDbType.Char
                        }).Value = DiaChiTextBox.Text;

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@error",
                            SqlDbType = SqlDbType.NVarChar,
                            Direction = ParameterDirection.Output
                        }).Value = "";


                        try
                        {
                            cn.Open();
                            cmd.ExecuteNonQuery();
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine($"[{ex.Message}]");

                        }
                    }

                }
            }
        }
    }
}

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
    public partial class ThemChuNha : Form
    {
        static string cnstr = @"Data Source =.; Initial Catalog = QuanLyThueBanNha; Integrated Security = True";
        public ThemChuNha()
        {
            InitializeComponent();
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            using (var cn = new SqlConnection { ConnectionString = cnstr })
            {
                using (var cmd = new SqlCommand
                {
                    Connection = cn,
                    CommandType = CommandType.StoredProcedure
                })
                {
                    cmd.CommandText = "dbo.[ThemChuNha]";

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
                        SqlDbType = SqlDbType.NVarChar
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

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
    public partial class ThemChiNhanh : Form
    {
        static string cnstr = @"Data Source =.; Initial Catalog = QuanLyThueBanNha; Integrated Security = True";
        public ThemChiNhanh()
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
                    cmd.CommandText = "dbo.[ThemChiNhanh]";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@sdt",
                        SqlDbType = SqlDbType.Char
                    }).Value = SDTTextBox.Text;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@fax",
                        SqlDbType = SqlDbType.Char
                    }).Value = FaxTextBox.Text;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@duong",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = DuongTextBox.Text;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@quan",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = QuanTextBox.Text;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@khuVuc",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = KhuVucTextBox.Text; 

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@thanhPho",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = ThanhphoTextBox.Text;

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

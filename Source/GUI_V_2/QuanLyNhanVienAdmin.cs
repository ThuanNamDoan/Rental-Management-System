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
    public partial class QuanLyNhanVienAdmin : Form
    {
        static string cnstr = @"Data Source =.; Initial Catalog = QuanLyThueBanNha; Integrated Security = True";
        public QuanLyNhanVienAdmin()
        {
            InitializeComponent();
        }

        private void QuanLyNhanVienAdmin_Load(object sender, EventArgs e)
        {
            using (var cn = new SqlConnection { ConnectionString = cnstr })
            {
                using (var cmd = new SqlCommand
                {
                    Connection = cn,
                    CommandType = CommandType.StoredProcedure
                })
                {
                    cmd.CommandText = "dbo.[XemThongTinNhanVien]";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@error",
                        SqlDbType = SqlDbType.NVarChar,
                        Direction = ParameterDirection.Output
                    }).Value = "";

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable ds = new DataTable();
                    da.Fill(ds);

                    NhanVienComboBox.ValueMember = "MaNhanVien";
                    NhanVienComboBox.DisplayMember = "MaNhanVien";
                    NhanVienComboBox.DataSource = ds;
                    NhanVienComboBox.SelectedIndex = -1;

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

        private void Button11_Click(object sender, EventArgs e)
        {
            using (var cn = new SqlConnection { ConnectionString = cnstr })
            {

                using (var cmd = new SqlCommand
                {
                    Connection = cn,
                    CommandType = CommandType.StoredProcedure
                })
                {
                    cmd.CommandText = "dbo.[CapNhatLuongNhanVien]";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maNhanVien",
                        SqlDbType = SqlDbType.Char
                    }).Value = NhanVienComboBox.Text;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@luongThem",
                        SqlDbType = SqlDbType.Money
                    }).Value = numericUpDown1.Value;

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
                    cmd.CommandText = "dbo.[XemThongTinNhanVienTheoLuong]";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@mucLuong",
                        SqlDbType = SqlDbType.Money
                    }).Value = numericUpDown2.Value;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@soLuong",
                        SqlDbType = SqlDbType.Money,
                        Direction = ParameterDirection.Output
                    }).Value = "";

                    SqlDataAdapter SDA = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    SDA.Fill(dt);
                    TablaProductos.DataSource = dt;

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

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
    public partial class QuanLyNhaChuNha: Form
    {
        static string cnstr = @"Data Source =.; Initial Catalog = QuanLyThueBanNha; Integrated Security = True";
        public QuanLyNhaChuNha()
        {
            InitializeComponent();
        }

        private void QuanLyNhaChuNha_Load(object sender, EventArgs e)
        {
            using (var cn = new SqlConnection { ConnectionString = cnstr })
            {
                using (var cmd = new SqlCommand
                {
                    Connection = cn,
                    CommandType = CommandType.StoredProcedure
                })
                {
                    cmd.CommandText = "dbo.[XemThongTinNha]";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maChuNha",
                        SqlDbType = SqlDbType.Char
                    }).Value = "own_1";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@error",
                        SqlDbType = SqlDbType.NVarChar,
                        Direction = ParameterDirection.Output
                    }).Value = "";

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable ds = new DataTable();
                    da.Fill(ds);

                    NhaComboBox.ValueMember = "MaNha";
                    NhaComboBox.DisplayMember = "MaNha";
                    NhaComboBox.DataSource = ds;
                    NhaComboBox.SelectedIndex = -1;

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

                using (var cmd = new SqlCommand
                {
                    Connection = cn,
                    CommandType = CommandType.StoredProcedure
                })
                {
                    cmd.CommandText = "dbo.[XemLoaiNha]";
                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@error",
                        SqlDbType = SqlDbType.NVarChar,
                        Direction = ParameterDirection.Output
                    }).Value = "";

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable ds = new DataTable();
                    da.Fill(ds);

                    LoaiNhaComboBox.ValueMember = "MaLoaiNha";
                    LoaiNhaComboBox.DisplayMember = "MaLoaiNha";
                    LoaiNhaComboBox.DataSource = ds;
                    LoaiNhaComboBox.SelectedIndex = -1;

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
                    cmd.CommandText = "dbo.[CapNhatNha]";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maNha",
                        SqlDbType = SqlDbType.Char
                    }).Value = NhaComboBox.Text;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@soLuongPhong",
                        SqlDbType = SqlDbType.Int
                    }).Value = 0;
                    
                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@tinhTrang",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = "";
                    
                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@duong",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = "";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@quan",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = "";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@thanhPho",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = "";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@khuVuc",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = "";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maGia",
                        SqlDbType = SqlDbType.Char
                    }).Value = "";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maChuNha",
                        SqlDbType = SqlDbType.Char
                    }).Value = "";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maNhanVien",
                        SqlDbType = SqlDbType.Char
                    }).Value = "";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maChiNhanh",
                        SqlDbType = SqlDbType.Char
                    }).Value = "";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maLoaiNha",
                        SqlDbType = SqlDbType.Char
                    }).Value = LoaiNhaComboBox.Text;

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

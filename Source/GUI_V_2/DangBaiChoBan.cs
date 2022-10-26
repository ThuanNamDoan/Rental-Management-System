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
    public partial class DangBaiChoBan : Form
    {
        static string cnstr = @"Data Source =.; Initial Catalog = QuanLyThueBanNha; Integrated Security = True";
        public DangBaiChoBan()
        {
            InitializeComponent();
        }
        
        private void DangBaiChoBan_Load(object sender, EventArgs e)
        {
            using (var cn = new SqlConnection { ConnectionString = cnstr })
            {
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
                    LoaiNhaComboBox.DisplayMember = "TenLoaiNha";
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
                    cmd.CommandText = "dbo.[ThemGia]";

                    string loaiGiaText= "";
                    if (NhaThueRadio.Checked)
                        loaiGiaText += "Thuê";
                    else
                        loaiGiaText += "Bán";

                    
                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@loaiGia",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = loaiGiaText;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@gia",
                        SqlDbType = SqlDbType.Money
                    }).Value = numericUpDown2.Value;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@dieuKienChuNha",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = "";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@error",
                        SqlDbType = SqlDbType.NVarChar,
                        Direction = ParameterDirection.Output
                    });

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@ma",
                        SqlDbType = SqlDbType.Char,
                        Direction = ParameterDirection.Output
                    });

                    //string a = (string)cmd.Parameters["@ma"].Value;
                    //int a = (int)cmd.Parameters["@ma"].Value;
                    

                    try
                    {
                        cn.Open();
                        cmd.ExecuteNonQuery();
                        //maGia = Convert.ToString(cmd.Parameters["@ma"].Value);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"[{ex.Message}]");
                    }
                    //label15.Text = maGia;

                }
                
                using (var cmd = new SqlCommand
                {
                    Connection = cn,
                    CommandType = CommandType.StoredProcedure
                })
                {
                    cmd.CommandText = "dbo.[ThemNha]";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@soLuongPhong",
                        SqlDbType = SqlDbType.Int
                    }).Value = numericUpDown1.Value;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@tinhTrang",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = TinhTrangTextBox.Text;

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
                        ParameterName = "@thanhPho",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = ThanhphoTextBox.Text;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@khuVuc",
                        SqlDbType = SqlDbType.NVarChar
                    }).Value = KhuVucTextBox.Text;

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maLoaiNha",
                        SqlDbType = SqlDbType.Char
                    }).Value = LoaiNhaComboBox.SelectedValue;

             

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maChuNha",
                        SqlDbType = SqlDbType.Char
                    }).Value = "own_1";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maNhanVien",
                        SqlDbType = SqlDbType.Char
                    }).Value = "emp_1";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@maChiNhanh",
                        SqlDbType = SqlDbType.Char
                    }).Value = "ag_1";

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

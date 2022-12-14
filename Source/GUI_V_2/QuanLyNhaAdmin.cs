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
    public partial class  QuanLyNhaAdmin: Form
    {
        static string cnstr = @"Data Source =.; Initial Catalog = QuanLyThueBanNha; Integrated Security = True";
        public QuanLyNhaAdmin()
        {
            InitializeComponent();
        }

        private void QuanLyNhaAdmin_Load(object sender, EventArgs e)
        {
            using (var cn = new SqlConnection { ConnectionString = cnstr })
            {
                using (var cmd = new SqlCommand
                {
                    Connection = cn,
                    CommandType = CommandType.StoredProcedure
                })
                {
                    cmd.CommandText = "dbo.[XemThongTinTatCaNha]";

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
            }

        }

        private void Button11_Click(object sender, EventArgs e)
        {
            using (var cn = new SqlConnection { ConnectionString = cnstr })
            {
                if (giaBanRadio.Checked)
                {
                    using (var cmd = new SqlCommand
                    {
                        Connection = cn,
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        cmd.CommandText = "dbo.[CapNhatGiaBan]";

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@maNha",
                            SqlDbType = SqlDbType.Char
                        }).Value = NhaComboBox.Text;

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@giaThem",
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
                else if (giaThueRadio.Checked)
                {
                    using (var cmd = new SqlCommand
                    {
                        Connection = cn,
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        cmd.CommandText = "dbo.[CapNhatGiaThue]";

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@maNha",
                            SqlDbType = SqlDbType.Char
                        }).Value = NhaComboBox.Text;

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@giaThem",
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
            }
        }
}

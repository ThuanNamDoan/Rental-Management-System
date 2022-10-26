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
    public partial class XemBaiDang : Form
    {
        static string cnstr = @"Data Source =.; Initial Catalog = QuanLyThueBanNha; Integrated Security = True";
        public XemBaiDang()
        {
            InitializeComponent();
        }
        DataTable ds = new DataTable();

        private void XemBaiDang_Load(object sender, EventArgs e)
        {
            using (var cn = new SqlConnection { ConnectionString = cnstr })
            {
                using (var cmd = new SqlCommand
                {
                    Connection = cn,
                    CommandType = CommandType.StoredProcedure
                })
                {
                    cmd.CommandText = "dbo.[XemThongTinBaiDang]";

                    cmd.Parameters.Add(new SqlParameter
                    {
                        ParameterName = "@error",
                        SqlDbType = SqlDbType.NVarChar,
                        Direction = ParameterDirection.Output
                    }).Value = "";

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    TablaProductos.DataSource = ds;


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
                if (giaBanRadio.Checked)
                {
                    using (var cmd = new SqlCommand
                    {
                        Connection = cn,
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        cmd.CommandText = "dbo.[ThongTinNhaTheoGiaBan]";

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@giaBan",
                            SqlDbType = SqlDbType.Money
                        }).Value = numericUpDown2.Value;

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
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

                else if (giaThueRadio.Checked)
                {
                    using (var cmd = new SqlCommand
                    {
                        Connection = cn,
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        cmd.CommandText = "dbo.[ThongTinNhaTheoGiaThue]";

                        cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "@giaThue",
                            SqlDbType = SqlDbType.Money
                        }).Value = numericUpDown1.Value;

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
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
}

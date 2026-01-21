package codemaster;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;


public class CodeDao {

	DBConnect db=new DBConnect();

	//그룹번호의 max값을 구해서 리턴(null이면 0리턴)
	public int getMaxGroup()
	{
		int max=0;
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select ifnull(max(group_code),0) max from code_master where code_id='*' "; 

		try {
			pstmt=conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
			
			if(rs.next())
			{
				max=rs.getInt("max");
				//max=rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return max;
	}

	//코드의 max값을 구해서 리턴(null이면 0리턴)
	public int getMaxCode(String groupCode, String codeId)
	{
		int max=0;
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select ifnull(max(group_code),0) max from code_master where code_id='*' "; 
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, groupCode);
			pstmt.setString(2, codeId);
			rs=pstmt.executeQuery();

			if(rs.next())
			{
				max=rs.getInt("max");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return max;
	}
	
	
	//1. 그룹 목록 조회
	public List<CodeDto> getGroupList()
	{
		
		List<CodeDto> list= new ArrayList<CodeDto>(); 
				

		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select distinct group_code, group_name,use_yn, create_id, create_day, update_id, update_day  FROM code_master where code_id='*' ORDER BY group_code";
				
		try {
			pstmt=conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				CodeDto dto=new CodeDto();

				dto.setGroup_code(rs.getString("group_code"));
				dto.setGroup_name(rs.getString("group_name"));
				dto.setUse_yn(rs.getString("use_yn"));
				dto.setCreate_id(rs.getString("create_id"));
				dto.setCreate_day(rs.getTimestamp("create_day"));
				dto.setUpdate_id(rs.getString("update_id"));
				dto.setUpdate_day(rs.getTimestamp("update_day"));

				list.add(dto);
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return list;
	}	
	
	//2. 그룹 등록
	public void insertGroup(CodeDto dto)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		String sql="insert into code_master(group_code, group_name, code_id, "
				+ "use_yn, create_id, create_day) VALUES (?, ?, '*', ?, ?, now())";

		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getGroup_code());
			pstmt.setString(2, dto.getGroup_name());
			pstmt.setString(3, dto.getUse_yn());
			pstmt.setString(4, dto.getCreate_id());

			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
	}
	
	//3. 수정용그룹 하나 조회	
	public CodeDto getGroup(String groupCode)
	{
	    CodeDto dto = null;

	    Connection conn = db.getDBConnect();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = "SELECT * FROM code_master WHERE group_code = ? and code_id='*' ";

	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, groupCode);

	        rs = pstmt.executeQuery();

	        if(rs.next()) {
	            dto = new CodeDto();
	            dto.setGroup_code(rs.getString("group_code"));
	            dto.setGroup_name(rs.getString("group_name"));
	            dto.setCode_id(rs.getString("code_id"));
	            dto.setCode_name(rs.getString("code_name"));
	            dto.setCreate_id(rs.getString("create_id"));
	            dto.setUpdate_id(rs.getString("update_id"));
	            dto.setUse_yn(rs.getString("use_yn").trim());
				dto.setSort_order(rs.getInt("sort_order"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));
	            dto.setUpdate_day(rs.getTimestamp("update_day"));
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return dto;
	}
	
	
	//4.그룹수정
	public void updateGroup(CodeDto dto)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		String sql="UPDATE code_master SET "
	               +"group_name = ?, "
	               +"use_yn = ?, "
	               +"update_day = NOW(), "
	               +"update_id = ? "
	               +"WHERE group_code = ? AND code_id = '*'";

		try {
			pstmt=conn.prepareStatement(sql);

			pstmt.setString(1, dto.getGroup_name());
			pstmt.setString(2, dto.getUse_yn());
			pstmt.setString(3, dto.getUpdate_id());
			pstmt.setString(4, dto.getGroup_code());
		
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
	}	
	
	//5. 그룹삭제 (하위 포함)
	public void deleteGroup(String groupCode)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		String sql="DELETE FROM code_master WHERE group_code = ? ";

		try {
			pstmt=conn.prepareStatement(sql);
			
			//바인딩하기
			pstmt.setString(1, groupCode);
			
			//실행
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
	}

	//코드등록 
	public void insertCode(CodeDto dto)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		String sql="insert into code_master values(?,?,?,?,?,?,now(),?,now(),?)";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getGroup_code());
			pstmt.setString(2, dto.getGroup_name());
			pstmt.setString(3, dto.getCode_id());
			pstmt.setString(4, dto.getCode_name());
			pstmt.setInt(5, dto.getSort_order());
			pstmt.setString(6, dto.getUse_yn());
			pstmt.setString(7, dto.getCreate_id());
			pstmt.setString(8, dto.getUpdate_id());

			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
	}
	

	//코드리스트 조회
	public List<CodeDto> getCodeList(String groupCode)
	{
		List<CodeDto> list=new ArrayList<CodeDto>();

		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from code_master where group_code =?  and code_id <> '*' order by  group_code asc, code_id asc";

		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, groupCode);
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				CodeDto dto=new CodeDto();
				
				dto.setGroup_code(rs.getString("group_code"));
				dto.setGroup_name(rs.getString("group_name"));
				dto.setCode_id(rs.getString("code_id"));
				dto.setCode_name(rs.getString("code_name"));
				dto.setUse_yn(rs.getString("use_yn"));
				dto.setSort_order(rs.getInt("sort_order"));
				dto.setCreate_id(rs.getString("create_id"));
				dto.setCreate_day(rs.getTimestamp("create_day"));
				dto.setUpdate_id(rs.getString("update_id"));
				dto.setUpdate_day(rs.getTimestamp("update_day"));
				
				list.add(dto);
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}

		return list;
		
	}
	
	
	//코드 삭제
	public int deleteCode(String groupCode, String codeId)
	{
	    int result = 0;
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
	
		String sql="DELETE FROM code_master WHERE group_code = ? AND code_id = ?";

		try {
			pstmt=conn.prepareStatement(sql);
			
			//바인딩하기
			pstmt.setString(1, groupCode);
			pstmt.setString(2, codeId);
			
			//실행
			result=pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return result;
	}
	
	//코드조회
	public CodeDto getCode(String groupCode, String codeId)
	{
		CodeDto dto=new CodeDto();
		
		Connection conn= db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from code_master where group_code = ? AND code_id = ?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, groupCode);
			pstmt.setString(2, codeId);

			rs= pstmt.executeQuery();
			
			if(rs.next())
			{
				
				dto.setGroup_code(rs.getString("group_code"));
				dto.setGroup_name(rs.getString("group_name"));
				dto.setCode_id(rs.getString("code_id"));
				dto.setCode_name(rs.getString("code_name"));
				dto.setUse_yn(rs.getString("use_yn"));
				dto.setSort_order(rs.getInt("sort_order"));
				dto.setCreate_id(rs.getString("create_id"));
				dto.setCreate_day(rs.getTimestamp("create_day"));
				dto.setUpdate_id(rs.getString("update_id"));
				dto.setUpdate_day(rs.getTimestamp("update_day"));
				
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return dto;
	}
		
	
	//코드 수정
	public int updateCode(CodeDto dto)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
	
		int result = 0;
		
		String sql = "UPDATE code_master SET code_name=?, sort_order=?, use_yn=?, "
				+ "update_day=NOW(), update_id=? WHERE group_code=? AND code_id=?";


		try {
			pstmt=conn.prepareStatement(sql);
			
	        pstmt.setString(1, dto.getCode_name());
	        pstmt.setInt(2, dto.getSort_order());
	        pstmt.setString(3, dto.getUse_yn());
	        
	     // update_id가 null이면 기본값으로 세팅해도 좋음
	        String updateId = dto.getUpdate_id() != null ? dto.getUpdate_id() : "system";
	        pstmt.setString(4, updateId);

	        pstmt.setString(5, dto.getGroup_code());
	        pstmt.setString(6, dto.getCode_id());

	        result = pstmt.executeUpdate();

	          
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		 return result;
	}

	//전체그룹갯수 반환
	public int getTotalCount()
	{
		int total=0;
		
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select count(*) from code_master where code_id='*' ";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			rs=pstmt.executeQuery();
			
			if(rs.next())
				total=rs.getInt(1);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		
		return total;
		
	}
	
	//그룹페이징 리스트
	public List<CodeDto> getPagingList(int start,int perpage)
	{
		List<CodeDto> list=new ArrayList<CodeDto>();
		
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from code_master where code_id='*' order by group_code desc limit ?,? ";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, start);
			pstmt.setInt(2, perpage);
			
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				CodeDto dto=new CodeDto();

				dto.setGroup_code(rs.getString("group_code"));
				dto.setGroup_name(rs.getString("group_name"));
				dto.setCode_id(rs.getString("code_id"));
				dto.setCode_name(rs.getString("code_name"));
				dto.setUse_yn(rs.getString("use_yn"));
				dto.setSort_order(rs.getInt("sort_order"));
				dto.setCreate_id(rs.getString("create_id"));
				dto.setCreate_day(rs.getTimestamp("create_day"));
				dto.setUpdate_id(rs.getString("update_id"));
				dto.setUpdate_day(rs.getTimestamp("update_day"));
				
				list.add(dto);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return list;
	}
	
	public boolean isCodeExists(String groupCode, String codeId) 
	{
		boolean  check=false;

		CodeDto dto=new CodeDto();
		
		Connection conn= db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		
		String sql="select count(*) from code_master where group_code = ? AND code_id = ?";
		
		try {

			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, groupCode);
	        pstmt.setString(2, codeId);
	        
			rs=pstmt.executeQuery();
				
			if(rs.next())
			{
				if(rs.getInt(1)==1)  
					check=true;
			}
				
		} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
		}finally {
				db.dbClose(rs, pstmt, conn);
		}
			
	      return check;
	}
	
}


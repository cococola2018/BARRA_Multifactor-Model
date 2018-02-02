function [Raw_Data_Stock,Raw_Date_Factor]=Load_Data(start_date)

Raw_Data_Stock=struct;
Raw_Date_Factor=struct;

myPath='C:\Users\wk199\Desktop\data_std_once\*.mat';
filename=dir(myPath);

for i=1:length(filename)
    load(filename(i).name);
end

id=find(datenum(Date_d)==datenum(start_date));
id_m=find(datenum(Date_m)>=datenum(start_date));

%以下是股票行情数据等读入
Raw_Data_Stock.Aclose=Aclose(id:end);
Raw_Data_Stock.Open=Open(id:end);
Raw_Data_Stock.Allcode=Allcode(id:end);
Raw_Data_Stock.Cap=Cap(id:end);
Raw_Data_Stock.Close=Close(id:end);
Raw_Data_Stock.Date_d=Date_d(id:end);
Raw_Data_Stock.Date_m=Date_m(id_m(1):end);
Raw_Data_Stock.Date_RID=Date_RID(id:end);
Raw_Data_Stock.INDU=INDU(id:end);
Raw_Data_Stock.ST_state=ST_state(id:end);
Raw_Data_Stock.Strade=Strade(id:end);

%以下是因子数据读入，根据具体情况可以继续添加因子数据
Raw_Date_Factor.Dp_ttm=Dp_ttm(id:end);
Raw_Date_Factor.Ebitda1_ttm=Ebitda1_ttm(id:end);
Raw_Date_Factor.PB=PB(id:end);
Raw_Date_Factor.Or_ttm=Or_ttm(id:end);
Raw_Date_Factor.Roa1_ttm=Roa1_ttm(id:end);
Raw_Date_Factor.Roe_ttm=Roe_ttm(id:end);

end

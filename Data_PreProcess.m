%*******************读入原始数据*********************
function [Raw_Data_Stock,Raw_Date_Factor]=Load_Data(start_date)

Raw_Data_Stock=struct;
Raw_Date_Factor=struct;

myPath='C:\Users\wk199\Desktop\data_std_once\*.mat';
filename=dir(myPath);

for i=1:length(filename)
    load(filename(i).name);
end

[rowid,~,~]=find(datenum(Date_d)==datenum(start_date));
[rowid_m,~,~]=find(datenum(Date_m)>=datenum(start_date));

%以下是股票行情数据等读入
Raw_Data_Stock.Aclose=Aclose(rowid:end,:);
Raw_Data_Stock.Open=Open(rowid:end,:);
Raw_Data_Stock.Allcode=Allcode(rowid:end,:);
Raw_Data_Stock.Cap=Cap(rowid:end,:);
Raw_Data_Stock.Close=Close(rowid:end,:);
Raw_Data_Stock.Date_d=Date_d(rowid:end,:);
Raw_Data_Stock.Date_m=Date_m(rowid_m(1):end);
Raw_Data_Stock.Date_RID=Date_RID(rowid:end,:);
Raw_Data_Stock.INDU=INDU(rowid:end,:);
Raw_Data_Stock.ST_state=ST_state(rowid:end,:);
Raw_Data_Stock.Strade=Strade(rowid:end,:);

%以下是因子数据读入，根据具体情况可以继续添加因子数据
Raw_Date_Factor.Dp_ttm=Dp_ttm(rowid:end,:);
Raw_Date_Factor.Ebitda1_ttm=Ebitda1_ttm(rowid:end,:);
Raw_Date_Factor.PB=PB(rowid:end,:);
Raw_Date_Factor.Or_ttm=Or_ttm(rowid:end,:);
Raw_Date_Factor.Roa1_ttm=Roa1_ttm(rowid:end,:);
Raw_Date_Factor.Roe_ttm=Roe_ttm(rowid:end,:);

end

%*******************处理异常值*********************
function [New_Data]=Delete_Outlier(Data)

[num_day,num_stock]=size(Data);

mean_value=mean(Data,2,'omitnan');
std_value=std(Data,0,2,'omitnan');

Data(Data>mean_value+3*std_value)=nan;
Data(Data<mean_value-3*std_value)=nan;
New_Data=Data;

end

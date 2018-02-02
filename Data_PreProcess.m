
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

mean_value=mean(Data,2,'omitnan');
std_value=std(Data,0,2,'omitnan');

Data(Data>mean_value+3*std_value)=nan;
Data(Data<mean_value-3*std_value)=nan;
New_Data=Data;

end

%*******************处理缺失值*********************
%处理方法包括直接删去缺失值，用每只股票的一段时间的均值替代，或用中位数替代
%MSCI USE4提出了用回归的方法填补缺失值，这里觉得不合适，暂未写代码，可留之后开发
function [New_Data]=MissingData_Replacement(Data,way)

Data(Data==0)=nan;%if no way is inputed, then we will simply delete the missing data
[~,num_stock]=size(Data);

if way=='insert_mean'
    Data(Data==0)=nan;
    mean_value=mean(Data,1,'omitnan');
    [~,num_stock]=size(Data);
    for i=1:num_stock
        data=Data(:,i);
        data(isnan(data))=mean_value(i);
        Data(:,i)=data;
    end
end

if way=='insert_median'
    median_value=median(Data,1,'omitnan');

    for i=1:num_stock
        data=Data(:,i);
        data(isnan(data))=median_value(i);
        Data(:,i)=data;
    end
end

%'Regress' way could also be added:regress non-missing exposures against a
%subset of factors, with the slope coefficients being used to estimate the factor exposures for the stocks
%with missing data.

New_Data=Data;

end

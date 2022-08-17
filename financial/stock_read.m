%StockInformationSHaseImportRoot是钱龙保存5分钟线的数据的文件路径，这里我选用600080
       StockInformationSHaseImportRoot = 'E:\Program Files\internet\securities\Vipdoc\sh\lday';
        if exist(StockInformationSHaseImportRoot) == 2
            file_id = fopen(StockInformationSHaseImportRoot, 'rb');         %打开文件
            raw_data = [1:1:10] ;                                                               %raw_data用于保存5分钟的各种数据
            while feof(file_id) == 0                                                             %循环读取600080.nmn的数据
                mi=fread(file_id,1,'ubit6'); %minutes                                    
                if mi<10
                    mistr=['0',num2str(mi)]; %分钟数是以为的补零，方便以后数据处理，以下同理            
                else
                    mistr=num2str(mi);
                end
                hr=fread(file_id,1,'ubit5'); %hour
                if hr<10
                    hrstr=['0',num2str(hr)];
                else
                    hrstr=num2str(hr);
                end
                dy=fread(file_id,1,'ubit5'); %day
                if dy<10
                    dystr=['0',num2str(dy)];
                else
                    dystr=num2str(dy);
                end
                mt=fread(file_id,1,'ubit4'); %month
                if mt<10
                    mtstr=['0',num2str(mt)];
                else
                    mtstr=num2str(mt);
                end
                yr=fread(file_id,1,'ubit12'); %year
                [row_array, ele_count] = fread(file_id, 9, 'int32') ;
                five5mn_date=strcat(num2str(yr),mtstr,dystr,hrstr,mistr);%把日期连在一起格式为：yyyymmddHHMM
                if ~isempty(five5mn_date)==1
                    row_array1(1)=str2double(five5mn_date);                   %把日期赋值给row_array1
                    row_array1(2:10)=row_array(1:9);                                %把开盘最高最低收盘成交量成交额赋值给row_array1
                    if ele_count < 9
                       break ;
                    else
                       raw_data = [raw_data; row_array1] ;                          %把每行数据连接起来     
                       clear row_array1 five5mn_date yr mt dy hr mi;
                    end
                    num=num+1;
                end
            end    
        end
           raw_data(1,:)=[] ;
          stockdatainfo(:,1) = raw_data(:,1);                 %时间
      stockdatainfo(:,2:5) = raw_data(:,2:5)/1000;        %开盘价，最高价，最低价，收盘价
      stockdatainfo(:,6) = raw_data(:,7);                 %成交量
      stockdatainfo(:,7) = round(raw_data(:,6)/100);       %成交额
      StockInformationExportRoot = strcat(StockInformationSHaseMatPathRoot, num2str(dayFileName)) ;  %StockInformationSHaseMatPathRoot保存的路径
           save(StockInformationExportRoot, 'stockdatainfo') %保存为day文件
           fclose(file_id);%关闭文件   
           clc;
           clear;

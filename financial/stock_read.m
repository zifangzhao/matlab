%StockInformationSHaseImportRoot��Ǯ������5�����ߵ����ݵ��ļ�·����������ѡ��600080
       StockInformationSHaseImportRoot = 'E:\Program Files\internet\securities\Vipdoc\sh\lday';
        if exist(StockInformationSHaseImportRoot) == 2
            file_id = fopen(StockInformationSHaseImportRoot, 'rb');         %���ļ�
            raw_data = [1:1:10] ;                                                               %raw_data���ڱ���5���ӵĸ�������
            while feof(file_id) == 0                                                             %ѭ����ȡ600080.nmn������
                mi=fread(file_id,1,'ubit6'); %minutes                                    
                if mi<10
                    mistr=['0',num2str(mi)]; %����������Ϊ�Ĳ��㣬�����Ժ����ݴ�������ͬ��            
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
                five5mn_date=strcat(num2str(yr),mtstr,dystr,hrstr,mistr);%����������һ���ʽΪ��yyyymmddHHMM
                if ~isempty(five5mn_date)==1
                    row_array1(1)=str2double(five5mn_date);                   %�����ڸ�ֵ��row_array1
                    row_array1(2:10)=row_array(1:9);                                %�ѿ������������̳ɽ����ɽ��ֵ��row_array1
                    if ele_count < 9
                       break ;
                    else
                       raw_data = [raw_data; row_array1] ;                          %��ÿ��������������     
                       clear row_array1 five5mn_date yr mt dy hr mi;
                    end
                    num=num+1;
                end
            end    
        end
           raw_data(1,:)=[] ;
          stockdatainfo(:,1) = raw_data(:,1);                 %ʱ��
      stockdatainfo(:,2:5) = raw_data(:,2:5)/1000;        %���̼ۣ���߼ۣ���ͼۣ����̼�
      stockdatainfo(:,6) = raw_data(:,7);                 %�ɽ���
      stockdatainfo(:,7) = round(raw_data(:,6)/100);       %�ɽ���
      StockInformationExportRoot = strcat(StockInformationSHaseMatPathRoot, num2str(dayFileName)) ;  %StockInformationSHaseMatPathRoot�����·��
           save(StockInformationExportRoot, 'stockdatainfo') %����Ϊday�ļ�
           fclose(file_id);%�ر��ļ�   
           clc;
           clear;

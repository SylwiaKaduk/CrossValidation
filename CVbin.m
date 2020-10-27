function [c,d]=CVbin(a,b)
%UNTITLED The function takes matrix a of the predictors and matrix b of the
%dependent variables as inputs. In a loop, it takes one row out from matrix
%a, trains a binomial model to predict b. It stores betas, qadjusted
%r-squared, errors, and p values. In the end it gives output of two arrays:
%arra c with four rows 1. averaged beta coeffients 2. averaged standard
%errors for coefficients 3. averaged tstatistics 4. averaged p values for t
%second array d gives 3 values in a row:  1. averaged adjusted r-squared and 2. averaged error of the
%estimation of each model
p=[];
adr=[];
SE=[];
tstat=[];
beta=[];
err=[];
rows=size(a,1);
columns=size(a,2);
for x=1:rows
    if x==1 %a specific case one the first row is the one that is left out
        %creating databases with testing, traing and dependnet sets
        train=a(2:rows,:);%choosing all the matrix for the training set except the first row
        test=a(1,:); %choosing first row a the testing set
        dep=b(2:rows,:); %choosing all the rows in the dependent variable that correspond to the training set
        testdep=b(1,:); %choosing test dependent variable
        %training the model
        [s,dev,stats]=glmfit(train,dep,'binomial','logit'); %training a binomial model
        %comparing the observed value with estimated value to calculate
        %error
        estimate=stats.beta; %calling values of the estimates 
        testtoest=[1 test]; %creating a table with all the test values and one before to multiply by estimates
        estval=estimate'.*testtoest; %multiplying coefficients by variables
        est=sum(estval,'all'); %summing all the products to get estomated value
        error=abs(est-testdep); %calculating error
        err=[err error]; %adding error to the err array to average in the end
        %getting beta values to the beta array
        beta=[beta; estimate']; %putting betas to the beta array
        %getting tstats values into the tstat array
        tstatval=stats.t; %getting array with tstat values
        tstat=[tstat; tstatval']; %putting the values to the tstat array to average in the end
        %getting se values into the se array
        seval=stats.se; %getting array with SE values
        SE=[SE; seval']; %putting the values to the se array to average in the end
        %getting p values into the p array
        pval=stats.p; %getting array with pvalues
        p=[p; pval']; %putting the values to the p array to average in the end
        %getting adjusted r squared value into the adr array
        [rsq1, adrsq1]=ModVar(a,stats.beta,columns,rows,b);
        adr=[adr adrsq1];
    else
        if x==rows %a specific case when the test row is the last row
             %creating databases with testing, traing and dependnet sets
             last=rows-1; %creating a variable that represents the last but one row of the matrix
        train=a(1:last,:);%choosing all the matrix for the training set except the last row
        test=a(rows,:); %choosing last row a the testing set
        dep=b(1:last,:); %choosing all the rows in the dependent variable that correspond to the training set
        testdep=b(x,:); %choosing test dependent variable
        %training the model
        [s,dev,stats]=glmfit(train,dep,'binomial','logit'); %training a linear model
        %comparing the observed value with estimated value to calculate
        %error
        estimate=stats.beta; %calling values of the estimates 
        testtoest=[1 test]; %creating a table with all the test values and one before to multiply by estimates
        estval=estimate'.*testtoest; %multiplying coefficients by variables
        est=sum(estval,'all'); %summing all the products to get estomated value
        error=abs(est-testdep); %calculating error
        err=[err error]; %adding error to the err array to average in the end
        %getting beta values to the beta array
        beta=[beta; estimate']; %putting betas to the beta array
        %getting tstats values into the tstat array
        tstatval=stats.t; %getting array with tstat values
        tstat=[tstat; tstatval']; %putting the values to the tstat array to average in the end
        %getting se values into the se array
        seval=stats.se; %getting array with SE values
        SE=[SE; seval']; %putting the values to the se array to average in the end
        %getting p values into the p array
        pval=stats.p; %getting array with pvalues
        p=[p; pval']; %putting the values to the p array to average in the end
        %getting adjusted r squared value into the adr array
        [rsq1, adrsq1]=ModVar(a,stats.beta,columns,rows,b);
        adr=[adr adrsq1];
        else %all the other cases
             %creating databases with testing, traing and dependnet sets
        train=[a(1:x-1,:); a(x+1:rows,:)];%creating a matrix that does not contain x row
        test=a(x,:); %choosing x row a the testing set
        dep=[b(1:x-1,:); b(x+1:rows,:)]; %choosing all the rows in the dependent variable that correspond to the training set
        tesdep=b(x,:); %choosing test dependent variable
        %training the model
        [s,dev,stats]=glmfit(train,dep,'binomial','logit'); %training a linear model
        %comparing the observed value with estimated value to calculate
        %error
        estimate=stats.beta; %calling values of the estimates 
        testtoest=[1 test]; %creating a table with all the test values and one before to multiply by estimates
        estval=estimate'.*testtoest; %multiplying coefficients by variables
        est=sum(estval,'all'); %summing all the products to get estomated value
        error=abs(est-testdep); %calculating error
        err=[err error]; %adding error to the err array to average in the end
        %getting beta values to the beta array
        beta=[beta; estimate']; %putting betas to the beta array
        %getting tstats values into the tstat array
        tstatval=stats.t; %getting array with tstat values
        tstat=[tstat; tstatval']; %putting the values to the tstat array to average in the end
        %getting se values into the se array
        seval=stats.se; %getting array with SE values
        SE=[SE; seval']; %putting the values to the se array to average in the end
        %getting p values into the p array
        pval=stats.p; %getting array with pvalues
        p=[p; pval']; %putting the values to the p array to average in the end
        %getting adjusted r squared value into the adr array
        [rsq1, adrsq1]=ModVar(a,stats.beta,columns,rows,b);
        adr=[adr adrsq1];
        end
    end
end
ap=nanmean(p);
atstat=nanmean(tstat);
ase=nanmean(SE);
aadr=nanmean(adr);
abeta=nanmean(beta);
aerr=nanmean(err);
c=[abeta; ase; atstat; ap]
d=[aadr aerr]
end


function [g s]= dc(cm,L,frequencies,labels,maxY,showLabel)
%DC draws on a graph the coherence index.

%% Setup
[m,n,d] = size(cm);
g = figure;hold on;

if length(frequencies)~=d
    error('Number of frequency labels wrong');
elseif length(labels)~=n
    error('Number of unit labels wrong');
end

xMin = frequencies(1)  -1;  %Bounds for xLim
xMax = frequencies(end)+1;

yMin = 0;                   %Bounds for yLim
ys = [];
for i=1:d
   ys = [ys ; triu(cm(:,:,i),1)]; 
end

yMax = max(max(ys))+0.01
yMax = maxY;

yL = 1 - 0.05^(1/(L-1));    %Height of the significance line

k = 1;  %Index for subplot

%% Plot as triangular array
for i=1:m-1
    for j=i+1:n
        x = reshape(cm(i,j,:),[1,d,1]); %Remove 3rd axis
        
        cp = (i-1)*(n-1) + (j-1);   %Current subplot position
        s(k) = subplot(m-1,n-1,cp);hold on;
        
        p(k) = plot(frequencies,x,'linewidth',2); %Plot against frequencies
        stem(frequencies,x);
        
        li(k) = line([xMin xMax],[yL yL]);   %Display significance line
        
        if showLabel=='y'
            %Specific graph formatting
            if i~=m-1
                set(gca,'xticklabel',[],'yticklabel',[]);
            else
                ylabel([labels{i}],'fontsize',20);
            end

            if i==1
                title([labels{j}],'fontsize',20);
            end

            if j==n
                ylabel([labels{i}],'fontsize',20);
            end
        end

        k = k+1;
    end
end

%% Additional formatting

set(li,'linestyle',':','linewidth',3,'color','k');
set(s,'xlim',[xMin xMax],'ylim',[yMin yMax],'yaxislocation','right');
set(s,'fontsize',20);
set(s(1:end-1),'xticklabel',[],'yticklabel',[]);

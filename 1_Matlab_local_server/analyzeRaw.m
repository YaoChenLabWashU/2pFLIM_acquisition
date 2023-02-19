function y=analyzeRaw(filename)
done=0;
counter=1;
counterstring = ['0' '0' num2str(counter)];
disp('a to decrement, d to increment, q to quit, dont key too fast...')
while ~done
    Aimg = imread([filename counterstring], 'tiff');
    figure(99)
    imshow(Aimg,[0 100])
    b = waitforbuttonpress;
    if b
        k = get(gcf, 'CurrentCharacter');
        switch k
            case 'd'
                counter = counter+1;
                if counter<10
                    counterstring = ['0' '0' num2str(counter)];
                elseif counter<100
                    counterstring = ['0' num2str(counter)];
                elseif counter<1000
                    counterstring = num2str(counter);
                else
                    disp('number too big!')
                end
            case 'a'
                counter = counter-1;
                if counter<10
                    counterstring = ['0' '0' num2str(counter)];
                elseif counter<100
                    counterstring = ['0' num2str(counter)];
                elseif counter<1000
                    counterstring = num2str(counter);
                else
                    disp('number too big!')
                end
            case 's'
                disp(counterstring)
            case 'q'
                done = 1;
            otherwise
                disp('unknown key pressed')
        end
    else
        done = 1;
    end
end
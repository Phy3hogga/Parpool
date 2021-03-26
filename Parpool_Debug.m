function Parpool_Debug = Parpool_Debug(Parpool_Debug, Status, First_Error_Only)
    if(First_Error_Only)
        if(0 > Parpool_Debug)
            %do nothing if less than 0
        else
            Parpool_Debug = Parpool_Debug + 1;
            if(~Status)
                Parpool_Debug = 0 - Parpool_Debug;
            end
        end
    else
        Parpool_Debug = Parpool_Debug + 1;
        if(~Status)
            Parpool_Debug = 0 - Parpool_Debug;
        end
    end
end
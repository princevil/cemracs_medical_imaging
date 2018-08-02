function [pure_cont] = remove_metadata(cont)

  metadata = [1];
  while metadata(end) <= size(cont,2)
    temp = metadata(end) + cont(2,metadata(end)) + 1;
    if temp >= size(cont,2) + 1;
      cont(:,metadata) = [];
      pure_cont = cont;
      break
    end
    metadata(end+1) = temp;
  end

  cont(:,metadata) = [];
  pure_cont = cont;

end

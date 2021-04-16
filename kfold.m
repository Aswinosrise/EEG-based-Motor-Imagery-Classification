partitionedModel1 = crossval(Msvm1,'KFold',10);
%partitionedModel2 = crossval(Msvm2,'KFold',10);
%partitionedModel3 = crossval(Msvm3,'KFold',10);
% Compute validation predictions
%[validationPredictions, validationScores] = kfoldPredict(partitionedModel);
% Compute validation accuracy   
validation_error1 = kfoldLoss(partitionedModel1, 'LossFun', 'ClassifError');% validation error
%validation_error2 = kfoldLoss(partitionedModel2, 'LossFun', 'ClassifError');
%validation_error3 = kfoldLoss(partitionedModel3, 'LossFun', 'ClassifError');
validationAccuracy1 = 1 - validation_error1
%validationAccuracy2 = 1 - validation_error2
%validationAccuracy3 = 1 - validation_error3
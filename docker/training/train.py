# MLOPS
from amlops.client.mlobasetrain import BaseTrain
from azureml.core import Run
import gc

# AC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.metrics import classification_report


class AdmisionCreditoTrain(BaseTrain):

    def train(self, run, mlflow, df_train, df_test, df_evaluation, extra_params: dict = None):

        # Clean environment with no used datasets
        del df_test
        gc.collect()

        # Get specific features and labels columns for training
        df_train_labels = df_train["Ind_SCF_Funded"]
        # Remove target/label columns and get only features/training columns
        df_train_set = df_train.drop(columns=['Ind_SCF_Funded'])
        # Clean resources
        del df_train
        gc.collect()

        # Get specific features and labels columns for training
        df_evaluation_labels = df_evaluation["Ind_SCF_Funded"]
        # Remove target/label columns and get only features/training columns
        df_evaluation_set = df_evaluation.drop(columns=['Ind_SCF_Funded'])
        # Clean resources
        del df_evaluation
        gc.collect()

        print("Recovering hyperparameters")
        # Train the model with the given configuration
        max_depth_space = extra_params['max_depth_space']
        n_estimators_space = extra_params['n_estimators_space']
        learning_rate_space = extra_params['learning_rate_space']

        DT = DecisionTreeClassifier(criterion='entropy', max_depth=max_depth_space, random_state=1)
        base_model = AdaBoostClassifier(base_estimator=DT,
                                        n_estimators=n_estimators_space,
                                        learning_rate=learning_rate_space,
                                        algorithm='SAMME',
                                        random_state=1)
        # Train model
        print("Fitting model")
        base_model.fit(df_train_set, df_train_labels)

        # Save trained model trained model
        print("Saving model")
        self.save_model(base_model)

        # Evaluate the model with the selected metric using the target/labels
        # and the predictions
        predicciones = base_model.predict(df_evaluation_set)

        # See: https://scikit-learn.org/stable/modules/generated/sklearn.metrics.classification_report.html
        score= classification_report(df_evaluation_labels.to_numpy(), predicciones, output_dict = True)['accuracy']

        # Register score metric
        run.log("score", score)


def main():
    # Create instance of DS implementation
    train = AdmisionCreditoTrain(Run.get_context())

    # Execute the train
    train.do_train()


if __name__ == '__main__':
    main()

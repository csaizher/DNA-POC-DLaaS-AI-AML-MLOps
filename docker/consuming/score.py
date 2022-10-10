# MLOPs
from azureml.core.run import Run
from amlops.client.mlobaseinference import BaseInference
from azureml.core import Workspace, Dataset
from azureml.core.model import Model
#AC
import pandas as pd


class AdmisionCreditoInference(BaseInference):

    def init(self, run, model):
        # Do nothing. This code is executed once time
        print("Nothing for initialization")

    def run(self, model, batch_dataset, extra_params: dict = {}):

        try:
            # Generate the predictions with the validation set
            preds = model.predict(batch_dataset)
            # Convert to dataframe for output
            preds = pd.DataFrame(preds)

            preds = preds.rename(columns={"index": "id"})
            preds['id'] = preds.index + 1
            preds = preds.rename(columns={0: 'Ind_SCF_Funded'})

            batch_dataset = batch_dataset.reset_index()
            batch_dataset = batch_dataset.rename(columns={"index": "id"})
            batch_dataset['id'] = batch_dataset.index + 1
            # Perform a join of the input data with the predictions
            # Note: It is validated that there are as many output records as
            # there are records provided in the input
            preds = pd.merge(batch_dataset, preds, on='id', how='outer')
            del preds['id']

        except Exception as e:
            error = str(e)
            print("Error on predict:  " + error)

        return preds


def init():

    # Global MLOPS object containing required data
    global inference

    # Create instance of user implementation
    inference = AdmisionCreditoInference(Run.get_context())

    # Execute inference initialization
    inference.do_init()


def run(batch_dataset):

    # Execute inference process
    return inference.do_run(batch_dataset)

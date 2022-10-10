from amlops.client.pipeline.mloregisterstepinference import MLORegisterStepInference

def main():

    # Execute Save Step actions
    MLORegisterStepInference.do_register_step()

if __name__ == '__main__':
    main()

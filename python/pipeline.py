from asyncio import constants
from aws_cdk import (
    aws_codebuild as codebuild,
    pipelines,
    Stack
)
from aws_cdk.pipelines import CodePipeline, ShellStep
from constructs import Construct
import constants


class Pipeline(Stack):
    def __init__(self,
        scope: Construct,
        construct_id: str,
        **kwargs
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)

        codepipeline_source = pipelines.CodePipelineSource.connection(
                                repo_string=f"{constants.GH_OWNER}/{constants.GH_REPO}",
                                branch=constants.GH_BRANCH,
                                connection_arn=constants.GH_CONN,
        )
        synth_python_version = {
            "phases": {
                "install": {
                    "runtime-versions": {"python": constants.CDK_PY_VER}
                }
            }
        }

        pipeline = CodePipeline(self, "cdk-pipeline",
                        pipeline_name="eks-cdk-pipeline",
                        synth=ShellStep("Synth",
                            input=codepipeline_source,
                            commands=["npm install -g aws-cdk",
                                "python -m pip install -r requirements.txt",                                 
                                "cdk synth"]
                            )
        )
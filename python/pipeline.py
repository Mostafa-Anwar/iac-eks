from asyncio import constants
from aws_cdk import (
    CfnParameter,
    Fn,
    aws_codebuild as codebuild,
    pipelines,
    Stack,
    CfnOutput,
    aws_ssm as ssm
)
from aws_cdk.pipelines import CodePipeline, ShellStep
from constructs import Construct
import constants
#import config


class Pipeline(Stack):
    def __init__(self,
        scope: Construct,
        construct_id: str,

        **kwargs
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)


        # self.ghrepo = ssm.StringParameter.from_string_parameter_name(self, 'gh-repo-param',
        #         string_parameter_name='gh_repo_string'
        #         ).string_value


        # self.pipebranch = ssm.StringParameter.from_string_parameter_name(self, 'pipeline-branch-param',
        #         string_parameter_name='pipe_repo'
        #         ).string_value


        # self.connarn = ssm.StringParameter.from_string_parameter_name(self, 'conn-arn-param',
        #         string_parameter_name='conn_arn'
        #         ).string_value

        # _param = ssm.StringParameter.value_from_lookup(self, parameter_name=('gh_repo'))

        # if "dummy-value-for" in _param:
        #     _param = ssm.StringParameter.value_from_lookup(self, parameter_name=('gh_repo'))

        
        codepipeline_source = pipelines.CodePipelineSource.connection(
                                repo_string=ssm.StringParameter.value_from_lookup(self, parameter_name="gh_repo"),
                                branch=ssm.StringParameter.value_from_lookup(self, parameter_name="pipe_repo"),
                                connection_arn=ssm.StringParameter.value_from_lookup(self, parameter_name="conn_arn")
        )
        synth_python_version = {
            "phases": {
                "install": {
                    "runtime-versions": {"python": constants.CDK_PY_VER}
                }
            }
        }
        ## TODO: store the constants in ssm params or CF outputs
        pipeline = CodePipeline(self, "cdk-pipeline",
                        pipeline_name="eks-cdk-pipeline",
                        synth=ShellStep("Synth",
                            input=codepipeline_source,
                            commands=["npm install -g aws-cdk",
                                "ls -al && cd python",
                                "python -m pip install -r requirements.txt",                                 
                                "cdk synth"]
                            )
        )
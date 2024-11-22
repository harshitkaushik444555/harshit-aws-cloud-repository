Follow the steps to deploy your app on AWS EKS
1. First install on your laptop and configure aws cli by providing your access key and secret access key.

2. Install Kubectl on your laptop.

3. Install eksctl on your laptop.
```
'eksctl' is a command-line tool specifically designed to simplify the process of creating, managing, and deleting 
Amazon EKS (Elastic Kubernetes Service) clusters. It is an open-source tool developed and maintained by Weaveworks in 
collaboration with AWS.
```

5. Install EKS cluster on AWS EKS using fargate eksctl command.It will take around 15-20 minutes, so wait.Using eksctl is easy way to create eks cluster.
```
eksctl create cluster --name demo-cluster --region us-east-1 --fargate
```
Here --fargate:
Specifies that this cluster will use AWS Fargate to run pods. Fargate is a serverless compute engine for containers that eliminates the need to provision or 
manage EC2 instances.When using Fargate, you don't manage the underlying infrastructure; AWS handles it, allowing you to focus entirely on your Kubernetes 
workloads.
   
Note: 
   
To delete already existing cluster go to CloudFormation in aws and select the cluster and delete it.

6. Next thing is to download kubeconfig file because you will not have to go to aws ui and inside the cluster to check resources like pods, service etc.

To download:
```
aws eks update-kubeconfig --name demo-cluster --region us-east-1
```

7. Now Proceed with deployment of actual application. create fargate profile and a namespace for the application using below commands. You cqn also use default
namespace.
```
       eksctl create fargateprofile \
    --cluster demo-cluster \
    --region us-east-1 \
    --name alb-sample-app \
    --namespace game-2048
```
8.  You can check fargate profile in compute tab of aws eks. 

9. Now Deploy the deployment, service and Ingress of the application using following command.
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/examples/2048/2048_full.yaml
```
This file contains details of deployment, ingress and service configuration related to application.This example is from eks official documentation.
  
Till now we have create deployment, ingress resource and service but there is no ingress controller.Without ingress controller the ingress resource is 
  
useless.

10. Try to run following command
```
kubectl get svc -n game-2048
```
You will get the port number and using this port and node ip or anybody who has access to aws vpc can access this app but our goal is to access this app from 
  
outside the aws or give access to user.For this we have created the ingress.External field ip will be nill.

10. run
```
kubectl get ingress -n game-2048
```
* in hosts indicate anyone can access but address is not there.Once we deploy ingress controller there will be an address.

11. Now we will create an ingress controller which will read ingress resource game-2048 and will create a load balancer, target group and port for us.

It just need an ingress resource.We will deploy an ALB controller.For this first we need to configure an oidc connector profile.We can deploy ALB controller 

without oidc connector but it will fail. Because ALB controller need to access the application load balancer bcz alb controller is nothing but a k8s pod and it

need to talk to some aws services.To talk it needs to have iam integrated.So we need to create a iam oidc provider.This is done in every organiztion.

12. Integrate iam oidc identity provider using below command
```
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve
```
13. To install alb controller you first need to download and create policy to give access to alb controller to aws resources. This is very big policy json file

and you don't need to learn anything about it because it is provided by alb controller and you can get it from alb controller documentation.

-download policy
```
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
```
-create policy
```
   aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
  ```
-create role
```
  eksctl create iamserviceaccount \
  --cluster=<your-cluster-name> \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```
We are attaching this role to a service account 'iamserviceaccount' because when a pod runs it will have a service account.So that this pod can talk to other
aws resources.

13. Now install actual alb controller
Add repo:
```
helm repo add eks https://aws.github.io/eks-charts
```
This helm chart will create the alb controller and it will use the service account to run the pod.

Update repo:
``` 
helm repo update eks
```
Install:
```
   helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
  --set clusterName=<your-cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region> \
  --set vpcId=<your-vpc-id>
```
Verify there should be two replicas 
```
kubectl get deployment -n kube-system aws-load-balancer-controller
```
14. Now check if LoadBalancer has been created in ec2 dashboard.You need to see a LB.You need to wait 2 minutes until load balancer state is active.

15. Run below command
```
kubectl get ingress -n game-2048
```
Output:
NAME           CLASS   HOSTS   ADDRESS                                                                  PORTS   AGE
ingress-2048   alb     *       k8s-game2048-ingress2-2eb4d6b389-362329306.us-east-1.elb.amazonaws.com   80      67m

Now ingress should have address using this you can access game-2048 application.

It is responsibility of devops engineer to just write the Pod deployment I mean if they are using deployment they'll write the deployment.yaml service.aml ingress.yaml and it is your one time responsibility to create the Ingress controller and rest is taken care by the Ingress controller.


FINISHED!!!!


Questions from above demonstration:
```

What is OpenId connect provider?
OpenID is an authentication protocol that allows users to sign in to applications and websites using an existing account 
from an identity provider.
With this eks cluster we created, we can integrate any identiry provider. In an identity provider you create a user and can attatch to 
many other things.Like login with FB and login with google these are social identity provider.Here we are integrating IAM identity provider.

What if we don't integrate IAM identity provider?
If a pod inside kubernetes cluster want to talk to S3 or cloudwatch then how will it will talk to these services if you don't integrate IAM 
identity provider.

Why we need namespace in eks ?
They are used to isolate, organize, and manage resources (like pods, deployments, and services) within a cluster. 

What is fargate profile in eks?
A Fargate profile in Amazon EKS (Elastic Kubernetes Service) is a configuration that defines which Kubernetes pods in your cluster should run on AWS Fargate. Fargate is a serverless compute engine for containers, meaning you don't have to manage the underlying EC2 instances—AWS provisions and manages the infrastructure for you. Here we are using different namespace.

What is default fargate profile in eks?
The default Fargate profile in Amazon EKS is a Fargate profile that is automatically created when you enable Fargate for your EKS cluster during cluster creation using eksctl or the AWS Management Console.The default profile includes the default and kube-system Kubernetes namespaces. Any pods deployed to these namespaces without specific node selectors will run on Fargate.

Why we need a fargate profile?
Creating a Fargate profile in Amazon EKS is essential for defining which Kubernetes pods will run on AWS Fargate, a serverless compute engine. Without a Fargate profile, pods won't be scheduled to Fargate, and workloads may remain unscheduled unless other compute resources (e.g., EC2 worker nodes) are available.

What is matchLabels in selectors field of deploymnet.yaml?
matchLabels is a key component within the selector field. It's used to define a set of label-value pairs that a Deployment uses to identify the Pods it 
manages.The matchLabels field within the Deployment's spec.selector specifies the labels that the Deployment's controller will use to identify the Pods it 
should manage.

What is selector in service.yaml?
The selector field is crucial for determining which Pods the Service should route traffic to. It acts as a filter, matching the labels on Pods with the labels specified in the selector.
```

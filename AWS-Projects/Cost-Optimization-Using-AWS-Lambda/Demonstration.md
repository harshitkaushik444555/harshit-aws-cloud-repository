AWS Cloud Cost Optimization - Identifying Stale Resources

Identifying Stale EBS Snapshots
```
In this example, we'll create a Lambda function that identifies EBS snapshots that are no longer associated with any active EC2
instance and deletes them to save on storage costs.
```
Description:
```
The Lambda function fetches all EBS snapshots owned by the same account ('self') and also retrieves a list of active EC2
instances (running and stopped). For each snapshot, it checks if the associated volume (if exists) is not associated with
any active instance. If it finds a stale snapshot, it deletes it, effectively optimizing storage costs.
```
Steps to perform this demo:
```
1. First login to your aws account
2. create an ec2 instance
3. Go to ec2 dashboard
4. select snapshots
5. create a snapshot of the volume attached to your current ec2 instance
6. Now in service search for lambda
7. create new function
8. Select author from scratch
9. give function name
10. In bottom click create function
11. In code tab paste code from ebs_stale_snapshosts.py file
12. click deploy
13. go to configurations tab and click permissions
14. click on service role link
15. assign following permission after creating policies manually
 -describe_snapshots
 -describe_snapshots
 -describe_volumes
 -delete_snapshot
16. now click test and give a name to the test
17. when you click test the snapshot won't be deleted because instance is running
18. now delete ec2 instance and run the function again by clicking test
19. snapshot will be deleted.
```

Finish!!!

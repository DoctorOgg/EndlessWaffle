# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

seedAmiInstanceTypeMatrix = AmiInstanceTypeMatrix.create([
  {family: 't2', virtualization_engine: 'hvm' ,storage_engine: 'ebs' },
  {family: 'm4', virtualization_engine: 'hvm',storage_engine: 'ebs'},
  {family: 'm3', virtualization_engine: 'hvm',storage_engine: 'ebs'},
  {family: 'm3', virtualization_engine: 'hvm',storage_engine: 'instance'},
  {family: 'm3', virtualization_engine: 'pv',storage_engine: 'ebs'},
  {family: 'm3', virtualization_engine: 'pv',storage_engine: 'instance'},
  {family: 'c4', virtualization_engine: 'hvm',storage_engine: 'ebs'},
  {family: 'c3', virtualization_engine: 'hvm',storage_engine: 'ebs'},
  {family: 'c3', virtualization_engine: 'hvm',storage_engine: 'instance'},
  {family: 'c3', virtualization_engine: 'pv',storage_engine: 'ebs'},
  {family: 'c3', virtualization_engine: 'pv',storage_engine: 'instance'},
  {family: 'x1', virtualization_engine: 'hvm',storage_engine: 'ebs'},
  {family: 'x1', virtualization_engine: 'hvm',storage_engine: 'instance'},
  {family: 'r3', virtualization_engine: 'hvm',storage_engine: 'ebs'},
  {family: 'r3', virtualization_engine: 'hvm',storage_engine: 'instance'},
  {family: 'g2', virtualization_engine: 'hvm',storage_engine: 'ebs'},
  {family: 'l2', virtualization_engine: 'hvm',storage_engine: 'ebs'},
  {family: 'l2', virtualization_engine: 'hvm',storage_engine: 'instance'},
  {family: 'd2', virtualization_engine: 'hvm',storage_engine: 'ebs'},
  {family: 'd2', virtualization_engine: 'hvm',storage_engine: 'instance'},
  {family: 'm1', virtualization_engine: 'pv',storage_engine: 'instance'},
  {family: 'm1', virtualization_engine: 'pv',storage_engine: 'ebs'}
  ])

seedCommands = Command.create(
  [
    {
      name: 'default_chef_provision',
      command: "#!/bin/bash\nknife ec2 server create \\\n  --run-list 'role[$CHEF_ROLE]' \\\n  --image $AMI \\\n  --flavor $INSTANCE_SIZE \\\n  --node-name $NAME.$ROLE.$ENVIRONMENT \\\n  --security-group-ids $SECURITY_GROUPS \\\n  --tags Name=$NAME,environment=$ENVIRONMENT,role=$ROLE,build_uuid=$UUID \\\n  --ssh-key $SSH_KEY_NAME \\\n  -i $SSH_KEY_PATH \\\n  --ssh-user $SSH_USER \\\n  --environment $ENVIRONMENT \\\n  --subnet $SUBNET_ID \\\n  --ebs-size $DISK_SIZE\n"
    },
    {
      name: 'default_chef_terminate',
      command: "#!/bin/bash\nknife client delete $NAME.$ROLE.$ENVIRONMENT -y\nknife node delete $NAME.$ROLE.$ENVIRONMENT -y\n"
    }
  ]
)

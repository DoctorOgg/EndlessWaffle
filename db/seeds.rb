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

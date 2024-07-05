import {DocumentData} from "firebase-admin/firestore";


export class ProjectEntity {
  id: string;
  organizationId: string;
  imagePath: string;
  title: string;
  subtitle: string;
  organizationDescription: string;
  description: string;
  condition: string;
  from: Date;
  to: Date | null;
  collected: number;
  goal: number;
  smallDonation: number;
  mediumDonation: number;
  bigDonation: number;

  constructor({id, organizationId, title, subtitle, imagePath, organizationDescription, description, condition, from, to, collected, goal, smallDonation, mediumDonation, bigDonation} : {
      id: string;
      organizationId: string;
      imagePath: string;
      title: string;
      subtitle: string;
      organizationDescription: string;
      description: string;
      condition: string;
      from: Date;
      to: Date | null;
      collected: number;
      goal: number;
      smallDonation: number;
      mediumDonation: number;
      bigDonation: number;
        }) {
    this.id = id;
    this.organizationId = organizationId;
    this.imagePath = imagePath;
    this.title = title;
    this.subtitle = subtitle;
    this.organizationDescription = organizationDescription;
    this.description = description;
    this.condition = condition;
    this.from = from;
    this.to = to;
    this.collected = collected;
    this.goal = goal;
    this.smallDonation = smallDonation;
    this.mediumDonation = mediumDonation;
    this.bigDonation = bigDonation;
  }

  static fromSnapshot(snapshot: DocumentData): ProjectEntity {
    const json = snapshot.data();
    const entity = new ProjectEntity({
      id: snapshot.id,
      organizationId: json.organizationId,
      imagePath: json.imagePath,
      title: json.title,
      subtitle: json.subtitle,
      organizationDescription: json.organizationDescription,
      description: json.description,
      condition: json.condition,
      collected: json.collected,
      goal: json.goal,
      smallDonation: json.smallDonation,
      mediumDonation: json.mediumDonation,
      bigDonation: json.bigDonation,
      from: json.from,
      to: json.to,

    });
    return entity;
  }

  static fromSnapshots(snapshots: DocumentData[]): ProjectEntity[] {
    const list: ProjectEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = ProjectEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}

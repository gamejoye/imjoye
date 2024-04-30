import { IUser } from '../../../types/User.type';
import { ClientUser } from './ClientUser';

export interface IClientUserService {
  getById(userId: number): Promise<ClientUser>;

  save(user: IUser): Promise<void>;
}
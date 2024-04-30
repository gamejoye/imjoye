import { IClientUserService } from './ClientUserService.interface';
import { ClientUser } from './ClientUser';
import relationStore from '@ohos.data.relationalStore';
import { CLIENT_USER } from '../../../constants/databaseTables';
import RdbHelper from '../RdbHelper';
import { IUser } from '../../../types/User.type';

class ClientUserService implements IClientUserService {
  async getById(userId: number): Promise<ClientUser | null> {
    const predicates = new relationStore.RdbPredicates(CLIENT_USER);
    predicates.equalTo('id', userId);
    const result = await RdbHelper.query(predicates);
    if (!result.goToFirstRow()) return null;
    return this.resultToClientUser(result);
  }

  async save(user: IUser): Promise<void> {
    const predicates = new relationStore.RdbPredicates(CLIENT_USER);
    predicates.equalTo('id', user.id);
    const result = await RdbHelper.query(predicates);
    const valueBucket = this.getClientUserBucket(user);
    if(result.rowCount) {
      await RdbHelper.update(valueBucket, predicates);
    } else {
      await RdbHelper.insert(CLIENT_USER, [valueBucket]);
    }
    const clientUserResult = await RdbHelper.query(predicates);
    if (!clientUserResult.goToFirstRow()) {
      throw new Error('save ClientUser fail');
    }
    return this.resultToClientUser(clientUserResult);
  }

  private getClientUserBucket(user: IUser): relationStore.ValuesBucket {
    const clientUser: ClientUser = {
      'id': user.id,
      'username': user.username,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'description': user.description,
      'createTime': user.createTime,
    }
    return { ...clientUser };
  }

  private resultToClientUser(result: relationStore.ResultSet): ClientUser {
    const clientUser: ClientUser = {
      id: result.getLong(result.getColumnIndex('id')),
      username: result.getString(result.getColumnIndex('username')),
      email: result.getString(result.getColumnIndex('email')),
      avatarUrl: result.getString(result.getColumnIndex('avatarUrl')),
      description: result.getString(result.getColumnIndex('description')),
      createTime: result.getString(result.getColumnIndex('createTime')),
    };
    return clientUser;
  }
}

const service = new ClientUserService();
export {
  service as ClientUserService,
};

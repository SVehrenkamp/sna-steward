# SNA Steward

An iOS application for managing SNA observations with Supabase integration.

## Supabase Setup

This project uses Supabase for backend services. The configuration has been set up with the following:

- Project: SNA Steward
- URL: https://tljzlugspnpwoxklejlg.supabase.co
- Region: us-east-2

### Environment Configuration

The project uses a `.env` file to store sensitive configuration values. To set up:

1. Copy `.env.example` to `.env` in the project root
2. Add your Supabase URL and anonymous key to the `.env` file:
   ```
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_KEY=your-anon-key
   ```

**Important**: Never commit the `.env` file to version control. It's already included in `.gitignore`.

### Database Schema

The database includes the following tables:

1. **observations** - Stores observation data:
   - id (UUID, primary key)
   - title (text)
   - description (text)
   - latitude (double precision)
   - longitude (double precision)
   - date (timestamp)
   - images (text array)
   - created_by (text)
   - created_at (timestamp)
   - updated_at (timestamp)

### Authentication

Supabase authentication is configured to allow:
- Email/password signup and login
- JWT token authentication
- Row-level security policies

## Project Structure

The project integrates with Supabase using the following components:

- **SupabaseManager** - Singleton to manage API connections
- **ObservationRepository** - Handles database operations for Observations
- **ObservationViewModel** - ViewModel for presenting observation data in the UI
- **DotEnv** - Utility for loading environment variables from `.env` file
- **EnvironmentVariables** - Access point for environment configuration values

## Development

To add the Supabase Swift package to the project:

1. In Xcode, go to File > Add Packages...
2. Enter the package URL: `https://github.com/supabase-community/supabase-swift`
3. Choose the latest version and add it to your target

## Environment Configuration

The Supabase URL and anonymous key are stored in:
- `.env` file (not committed to source control)
- Accessed through the `EnvironmentVariables` utility

For security in production, consider using a proper secrets management approach. 
// Types for the Supabase schema in supabase/migrations. Hand-written because
// `supabase gen types` needs a CLI login; replace this file with the generated
// one (`supabase gen types typescript --project-id <id>`) when convenient.

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

type CourseLevel = "Beginner" | "Intermediate" | "Advanced";
type CourseKind = "course" | "live";
type CourseStatus = "draft" | "published";
type Provider = "anthropic" | "openai" | "google";
type UserRole = "user" | "admin";

export type Database = {
  public: {
    Tables: {
      profiles: {
        Row: { id: string; email: string | null; role: UserRole; created_at: string };
        Insert: { id: string; email?: string | null; role?: UserRole; created_at?: string };
        Update: { id?: string; email?: string | null; role?: UserRole; created_at?: string };
        Relationships: [];
      };
      courses: {
        Row: {
          id: string;
          slug: string;
          title: string;
          short_description: string;
          thumbnail_url: string | null;
          footer_text: string;
          level: CourseLevel;
          kind: CourseKind;
          provider: Provider;
          prices: Json;
          status: CourseStatus;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          slug: string;
          title: string;
          short_description?: string;
          thumbnail_url?: string | null;
          footer_text?: string;
          level?: CourseLevel;
          kind?: CourseKind;
          provider?: Provider;
          prices?: Json;
          status?: CourseStatus;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          slug?: string;
          title?: string;
          short_description?: string;
          thumbnail_url?: string | null;
          footer_text?: string;
          level?: CourseLevel;
          kind?: CourseKind;
          provider?: Provider;
          prices?: Json;
          status?: CourseStatus;
          created_at?: string;
          updated_at?: string;
        };
        Relationships: [];
      };
      units: {
        Row: { id: string; course_id: string; position: number; title: string; summary: string };
        Insert: { id?: string; course_id: string; position: number; title: string; summary?: string };
        Update: { id?: string; course_id?: string; position?: number; title?: string; summary?: string };
        Relationships: [];
      };
      lessons: {
        Row: {
          id: string;
          unit_id: string;
          position: number;
          title: string;
          content: string;
          video_url: string | null;
          duration_minutes: number;
        };
        Insert: {
          id?: string;
          unit_id: string;
          position: number;
          title: string;
          content?: string;
          video_url?: string | null;
          duration_minutes?: number;
        };
        Update: {
          id?: string;
          unit_id?: string;
          position?: number;
          title?: string;
          content?: string;
          video_url?: string | null;
          duration_minutes?: number;
        };
        Relationships: [];
      };
      announcements: {
        Row: {
          id: string;
          title: string;
          body: string;
          image_url: string | null;
          link_url: string | null;
          active: boolean;
          sort_order: number;
          created_at: string;
        };
        Insert: {
          id?: string;
          title: string;
          body?: string;
          image_url?: string | null;
          link_url?: string | null;
          active?: boolean;
          sort_order?: number;
          created_at?: string;
        };
        Update: {
          id?: string;
          title?: string;
          body?: string;
          image_url?: string | null;
          link_url?: string | null;
          active?: boolean;
          sort_order?: number;
          created_at?: string;
        };
        Relationships: [];
      };
      enrollments: {
        Row: { user_id: string; course_id: string; stripe_session_id: string; created_at: string };
        Insert: { user_id: string; course_id: string; stripe_session_id: string; created_at?: string };
        Update: { user_id?: string; course_id?: string; stripe_session_id?: string; created_at?: string };
        Relationships: [];
      };
    };
    Views: {
      lesson_outline: {
        Row: {
          id: string | null;
          unit_id: string | null;
          position: number | null;
          title: string | null;
          duration_minutes: number | null;
        };
        Relationships: [];
      };
    };
    Functions: {
      is_admin: { Args: Record<PropertyKey, never>; Returns: boolean };
      has_course_access: { Args: { p_course_id: string }; Returns: boolean };
    };
    Enums: {
      user_role: UserRole;
      course_level: CourseLevel;
      course_kind: CourseKind;
      course_status: CourseStatus;
      provider: Provider;
    };
    CompositeTypes: { [_ in never]: never };
  };
};
